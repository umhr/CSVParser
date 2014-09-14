package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class WonderflMain extends Sprite 
	{
		
		public function WonderflMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(new Canvas());
		}
		
	}
	
}

	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	//import jp.mztm.umhr.logging.Log;
	/**
	 * ...
	 * @author umhr
	 */
	class Canvas extends Sprite 
	{
		
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			new PushButton(this, 16, 16, "load .csv file", onStartLoad);
			
			addChild(new Log(16,48,465-32,465-48));
		}
		
		private function onStartLoad(event:Event):void {
			var fetchFile:FetchFile = new FetchFile();
			fetchFile.addEventListener(Event.COMPLETE, fetchFile_complete);
			fetchFile.start([new FileFilter("Documents", "*.csv")]);
		}
		
		private function fetchFile_complete(e:Event):void 
		{
			var fetchFile:FetchFile = e.target as FetchFile;
			fetchFile.removeEventListener(Event.COMPLETE, fetchFile_complete);
			var text:String = String(fetchFile.content);
			Log.clear();
			Log.trace(parseCSV(text));
		}
		
		/**
		 * [JavaScript][Perl] 続・正規表現を使ったCSVパーサ / LiosK-free Blog
		 * http://liosk.blog103.fc2.com/blog-entry-75.html
		 * @param	text
		 * @param	delim
		 * @param	'
		 * @return
		 */
		private function parseCSV(text:String, delim:String = ','):Array {
			var tokenizer:RegExp = new RegExp(delim + '|\r?\n|[^' + delim + '"\r\n][^' + delim + '\r\n]*|"(?:[^"]|"")*"', 'g');
			
			var record:int = 0;
			var field:int = 0;
			var data:Array = [[]];
			var qq:RegExp = /""/g;
			text.replace(/\r?\n$/, '').replace(tokenizer, function(token:*):* {
				switch (token) {
					case delim: 
						data[record][++field] = '';
						break;
					case '\n': case '\r\n':
						data[++record] = [''];
						field = 0;
						break;
					default:
						data[record][field] = (token.charAt(0) != '"') ? token : token.slice(1, -1).replace(qq, '"');
				}
			});
			
			return data;
		}
	}
	

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author umhr
	 */
	 class FetchFile extends EventDispatcher 
	{
		public var content:Object;
		public var type:String;
		private var _fileReference:FileReference;
		public function FetchFile(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
		}
		public function start(typeFilter:Array = null):void{
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.SELECT, atSelect);
			_fileReference.browse(typeFilter);
		}
		private function atSelect(event:Event):void {
			_fileReference.removeEventListener(Event.SELECT, atSelect);
			_fileReference.addEventListener(Event.COMPLETE, atFileComplete);
			_fileReference.load();
		}
		private function atFileComplete(event:Event):void {
			_fileReference.removeEventListener(Event.COMPLETE, atFileComplete);
			type = _fileReference.type.toLowerCase();
			if (isByteArray(type)) {
				loaderStart();
			}else if (type == ".zip") {
				//new ZipDecompressor().zipDecompression(_fileReference.data).addEventListener(Event.COMPLETE, zipDecompressor_complete);
			}else {
				urlLoaderStart();
			}
		}
		/*
		private function zipDecompressor_complete(event:Event):void 
		{
			var zipDecompressor:ZipDecompressor = event.target as ZipDecompressor;
			zipDecompressor.removeEventListener(Event.COMPLETE, zipDecompressor_complete);
			content = zipDecompressor.images;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		*/
		
		/**
		 * 拡張子が指定の場合はByteArrayとする。
		 * @param	type
		 * @return
		 */
		private function isByteArray(type:String):Boolean {
			var list:Array/*String*/ = [".jpg", ".png", ".gif"];
			for each (var extention:String in list) {
				if (extention == type) {
					return true;
				}
			}
			return false;
		}
		
		private function urlLoaderStart():void {
			content = _fileReference.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loaderStart():void {
			var loader:Loader = new Loader();
			loader.loadBytes(_fileReference.data, new LoaderContext());
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, atBytesComplete);
		}
		
		private function atBytesComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, atBytesComplete);
			content = event.target.content;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * traceを
	 * @author umhr
	 */
	
	class Log extends Sprite
	{
		static private var _tracer:Tracer;
		static private var _textField:TextField;
		static private var _date:Date;
		static private var _width:int;
		static private var _height:int;
		
		public function Log(x:Number = 0, y:Number = 0, width:int = 800, height:int = 600) 
		{
			this.x = x;
			this.y = y;
			_width = width;
			_height = height;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(getTextField());
			mouseEnabled = false;
		}
		static public function clear():void {
			_textField.text = "";
			_date = null;
		}
		
		static private function getTextField():TextField {
			if (!_textField) {
				_textField = new TextField();
			}
			_textField.textColor = 0xFF0000;
			_textField.width = _width;
			_textField.height = _height;
			_textField.mouseEnabled = false;
			_textField.wordWrap = _textField.multiline = true;
			return _textField;
		}
		
		static public function trace(... arguments):void {
			
			if (!_tracer) {
				_tracer = new Tracer();
			}
			
			var msg:String = _tracer.show(arguments);
			
			if (_textField) {
				_textField.appendText(msg + "\n");
			}
		}
		
		static public function traceTime(... arguments):void {
			
			if (!_tracer) {
				_tracer = new Tracer();
			}
			
			if (!_date) {
				_date = new Date();
			}
			
			var time:uint = new Date().time - _date.time;
			
			var msg:String = _tracer.withTime(time, arguments);
			
			if (_textField) {
				_textField.appendText(msg + "\n");
			}
		}
		
		static public function timeReset():void {
			_date = null;
		}
		
		
		
		static public function dump(obj:Object, useLineFeed:Boolean = false):String {
			var str:String = returnDump(obj)
			if (!useLineFeed) {
				str = str.replace(/\n/g, "");
			}
			trace(str);
			return str;
		}
		
		static private function returnDump(obj:Object):String {
			var str:String = _dump(obj);
			if (str.length == 0) {
				str = String(obj);
			}else if (getQualifiedClassName(obj) == "Array") {
				str = "[\n" + str.slice( 0, -2 ) + "\n]";
			}else {
				str = "{\n" + str.slice( 0, -2 ) + "\n}";
			}
			return str;
		}
		
		static private function _dump(obj:Object, indent:int = 0):String {
			var result:String = "";
			
			var da:String = (getQualifiedClassName(obj) == "Array")?'':'"';
			
			var tab:String = "";
			for ( var i:int = 0; i < indent; ++i ) {
				tab += "    ";
			}
			
			for (var key:String in obj) {
				if (typeof obj[key] == "object") {
					var type:String = getQualifiedClassName(obj[key]);
					if (type == "Object" || type == "Array") {
						result += tab + da + key + da + ":"+((type == "Array")?"[":"{");
						var dump_str:String = _dump(obj[key], indent + 1);
						if (dump_str.length > 0) {
							result += "\n" + dump_str.slice(0, -2) + "\n";
							result += tab;
						}
						result += (type == "Array")?"],\n":"},\n";
					}else {
						result += tab + '"' + key + '":<' + type + ">,\n";
					}
				}else if (typeof obj[key] == "function") {
					result += tab + '"' + key + '":<Function>,\n';
				}else {
					var dd:String = (typeof obj[key] == "string")?"'":"";
					result += tab + da + key + da + ":" + dd + obj[key] +dd + ",\n";
				}
			}			
			return result;
		}
		
	}
	


class Tracer {
	public function Tracer() {
		
	}
	public function show(... arguments):String {
		var result:String = "Log : " + arguments.join(" ");
		trace(result);
		return result;
	}
	public function withTime(time:uint, arg:Array):String {
		var result:String = "Log : " + time + " : " + arg.join(" ");
		trace(result);
		return result;
	}
	
}