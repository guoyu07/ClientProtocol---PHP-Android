package suity.utils 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import org.papervision3d.materials.ColorMaterial;
	/**
	 * ...
	 * @author ase7en
	 */
	public class ColorUtils 
	{
		/**
		 * 修改显示对象亮度
		 * @param	child
		 * @param	value 【-255，255】
		 */
		public static function setBrightness(child:DisplayObject, value:int):void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, value]);
			matrix = matrix.concat([0, 1, 0, 0, value]);
			matrix = matrix.concat([0, 0, 1, 0, value]);
			matrix = matrix.concat([0, 0, 0, 1, 0]);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = [];
			filters.push(filter);
			child.filters = filters;
		}
		
	}

}