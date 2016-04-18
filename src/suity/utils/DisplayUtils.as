package suity.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import suity.common.DisplayEntity;
	import tweener.fl9.Tweener;
	
	/**
	 * 显示工具
	 * @author Simage
	 */
	public class DisplayUtils 
	{
		public static function Unparent($display:DisplayObject):void {
			if ($display == null) return;
			if ($display.parent == null) return;
			
			$display.parent.removeChild($display);
		}
		
		/**
		 * 放置一个$display到$container容器里面去
		 * @param	$display 被放置的显示对象
		 * @param	$container 放置进去的容器
		 */
		public static function PlaceTo($display:DisplayObject, $container:DisplayObjectContainer):void {
			if ($display == null) throw new Error();
			if ($display.parent == $container) return;
			Unparent($display);
			$container.addChild($display)
		}
		
		public static function BringToFront($display:DisplayObject):void {
			$display.parent.setChildIndex($display, $display.parent.numChildren - 1);
		}
		
		public static function SendToBack($display:DisplayObject):void {
			$display.parent.setChildIndex($display, 0);
		}
		
		public static function SetZIndex($display:DisplayObject, $index:int):void {
			if ($display != null && $display.parent != null) {
				$display.parent.setChildIndex($display, $index);
			}
		}
		public static function SetOrderAbove($display:DisplayObject, $target:DisplayObject):void {
			if ($target == null) throw new Error();
			if ($target == $display) throw new Error();
			if ($target.parent != $display.parent) throw new Error();
			if ($display.parent == null) throw new Error();
			
			var $i:int = $target.parent.getChildIndex($target);
			$display.parent.setChildIndex($display, $i + 1);
		}
		public static function SetOrderBehind($display:DisplayObject, $target:DisplayObject):void {
			if ($target == null) throw new Error();
			if ($target == $display) throw new Error();
			if ($target.parent != $display.parent) throw new Error();
			if ($display.parent == null) throw new Error();
			
			var $i:int = $target.parent.getChildIndex($target);
			$display.parent.setChildIndex($display, $i);
		}
		
		public static function FlashDisObj($display:MovieClip):void
		{
			if ($display == null) throw new Error();
			toOver($display);
		}
		
		private static function toOver($display:MovieClip):void
		{
			$display.gotoAndStop("over");
			Tweener.addTween($display, { time:10, onComplete:toUp, onCompleteParams:[$display] } );
		}
		
		private static function toUp($display:MovieClip):void
		{
			$display.gotoAndStop("up");
			Tweener.addTween($display, { time:10, onComplete:toOver, onCompleteParams:[$display] } );
		}

	}
	
}