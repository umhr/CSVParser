package jp.mztm.umhr.create
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author umhr
	 */
	public class Gradation {
		public function Gradation() { };
		
		/**
		 * RoundRectのグラデーションを設定します。
		 * @param    target graphicを持つインスタンス
		 * @param    x
		 * @param    y
		 * @param    width
		 * @param    height
		 * @param    r 丸角の描画に使用される楕円の幅
		 * @param    colors
		 * @param    alphas
		 * @param    rations
		 */
		static public function drawGradientRoundRect(target:*, x:Number, y:Number, width:Number, height:Number, r:Number, colors:Array, alphas:Array = null, rations:Array = null):void {
			
			var n:int = colors.length;
			var i:int;
			var d:Number;
			
			if (n == 1) {
				var rgb:uint = colors[0];
				colors[1] = rgb;
				n = 2;
			}
			
			if (!alphas) {
				alphas = [];
				for (i = 0; i < n; i++) 
				{
					alphas.push(1);
				}
			}
			if (!rations) {
				rations = [];
				for (i = 0; i < n; i++) 
				{
					d = i / (n - 1);
					rations.push(Math.floor(d * 255));
				}
			}
			target.graphics.beginGradientFill.apply(null, gradientFill(y, height, colors, alphas, rations));
			target.graphics.drawRoundRect(x, y, width, height, r, r);
			target.graphics.endFill();
		}
		
		/**
		 * Circleのグラデーションを設定します。
		 * @param    target
		 * @param    x
		 * @param    y
		 * @param    r
		 * @param    colors
		 * @param    alphas
		 * @param    rations
		 */
		static public function drawGradientCircle(target:*,x:Number, y:Number, r:int, colors:Array, alphas:Array, rations:Array):void {
			target.graphics.beginGradientFill.apply(null, gradientFill(y - r, r + r, colors, alphas, rations));
			target.graphics.drawCircle(x, y, r);
			target.graphics.endFill();
		}
		
		static private function gradientFill(y:Number, height:int, colors:Array, alphas:Array, rations:Array):Array {
			var result:Array = [GradientType.LINEAR, colors, alphas, rations];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(1, height, Math.PI * 0.5, 0, y);
			result.push(matrix);
			return result;
		}
		
		/**
		 * 色の明度を相対的に変えます。
		 * rgb値と割合を与えて、結果を返す。
		 * rgbは、0xffffff段階の値。
		 * ratioが0の時に0x000000に、1の時にそのまま、2の時には0xffffffになる。
		 * 相対的に、ちょっと暗くしたい時には、ratioを0.8に、
		 * ちょっと明るくしたい時にはratioを1.2などに設定する。
		 * @param    rgb
		 * @param    ratio
		 * @return
		 */
		static public function rgbBrightness(rgb:int, ratio:Number):int {
			if(ratio < 0 || 2 < ratio){ratio = 1;trace("function colorBrightness 範囲外")}
			var _r:int = rgb >> 16;//16bit右にずらす。
			var _g:int = rgb >> 8 & 0xff;//8bit右にずらして、下位8bitのみを取り出す。
			var _b:int = rgb & 0xff;//下位8bitのみを取り出す。
			if(ratio <= 1){
				_r *= ratio;
				_g *= ratio;
				_b *= ratio;
			}else{
				_r = (255 - _r)*(ratio-1)+_r;
				_g = (255 - _g)*(ratio-1)+_g;
				_b = (255 - _b)*(ratio-1)+_b;
			}
			return _r<<16 | _g<<8 | _b;
		}
		
	}
}