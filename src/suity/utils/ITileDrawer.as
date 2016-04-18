package suity.utils
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Simage
	 */
	public interface ITileDrawer
	{
		function DrawTileByUV($graphics:Graphics, $uSource:int, $vSource:int, $uTarget:int, $vTarget:int, $flipU:Boolean = false, $flipV:Boolean = false):void;
	}

}