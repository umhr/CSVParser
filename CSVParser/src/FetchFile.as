package  
{
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
	public class FetchFile extends EventDispatcher 
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

}