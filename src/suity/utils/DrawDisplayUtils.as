package suity.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * 把display绘画成图片的静态方法
	 * @author weeky
	 */
	public class DrawDisplayUtils
	{
		/**
		 * 绘画方法
		 * @param	$source  绘画元素
		 * @param	$w       宽度
		 * @param	$h       高度
		 * @param	$startX  绘画X起始坐标
		 * @param	$startY  绘画Y起始坐标
		 * @return  返回bitmapdata
		 */
		public static function Create($source:DisplayObject, $w:Number, $h:Number, $startX:Number = 0, $startY:Number = 0):BitmapData {
			if ($source == null) throw new Error();
			if ($w <= 0) throw new Error();
			if ($h <= 0) throw new Error();
			
			// 重新创建缓冲
			var $data:BitmapData = new BitmapData($w, $h, true, 0x00000000);

			// 按照缩放创建一个matrix
			var $matrix:Matrix = new Matrix(1, 0, 0, 1, -$startX, -$startY);
			
			$data.fillRect(new Rectangle(0, 0, $data.width, $data.height), 0x00000000);
			$data.draw($source, $matrix);
			return $data;
		}
	}

}