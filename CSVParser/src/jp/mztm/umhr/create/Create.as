package jp.mztm.umhr.create 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author umhr
	 */
	public class Create 
	{
		
		static public function spriteRect(x:int = 0, y:int = 0, width:int = 100, height:int = 100, rgb:int = 0xFFFFFF, alpha:Number = 1):Sprite {
			var result:Sprite = new Sprite();
			result.graphics.beginFill(rgb, alpha);
			result.graphics.drawRect(x, y, width, height);
			result.graphics.endFill();
			return result;
		}
		
		static public function spriteCircle(x:int = 0, y:int = 0, radius:int = 100, rgb:int = 0xFFFFFF, alpha:Number = 1):Sprite {
			var result:Sprite = new Sprite();
			result.graphics.beginFill(rgb, alpha);
			result.graphics.drawCircle(x, y, radius);
			result.graphics.endFill();
			return result;
		}
		
		static public function shapeRect(x:int = 0, y:int = 0, width:int = 100, height:int = 100, rgb:int = 0xFFFFFF, alpha:Number = 1):Shape {
			var result:Shape = new Shape();
			result.graphics.beginFill(rgb, alpha);
			result.graphics.drawRect(x, y, width, height);
			result.graphics.endFill();
			return result;
		}
		
		
		
		/**
		 * 新規に初期化したTextFiledを返します。引数に関わらず、fontはSettingDataで指定したもの、selectable=false、mouseEnabled=false、multiline=true、wordWrap=trueになります。
		 * 必要なときは、別途指定してください。
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	text
		 * @param	textFormat　
		 * @return	新規に初期化したTextFiled
		 */
		static public function textField(x:int = 0, y:int = 0, width:int = 100, height:int = 100, text:String = "", textFormat:TextFormat = null):TextField {
			if (!textFormat) {
				textFormat = new TextFormat();
			}
			
			textFormat.font = textFormat.font;
			var result:TextField = new TextField();
			result.defaultTextFormat = textFormat;
			result.x = x;
			result.y = y;
			result.width = width;
			result.height = height;
			result.text = text;
			result.selectable = false;
			result.mouseEnabled = false;
			
			return result;
		}
		
		public function Create() 
		{
			
		}
	}
}