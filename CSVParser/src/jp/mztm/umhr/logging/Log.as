package jp.mztm.umhr.logging 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * traceを
	 * @author umhr
	 */
	
	public class Log extends Sprite
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