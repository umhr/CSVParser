package  
{
	
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import jp.mztm.umhr.logging.Log;
	import jp.mztm.umhr.Utils;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
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
	
}