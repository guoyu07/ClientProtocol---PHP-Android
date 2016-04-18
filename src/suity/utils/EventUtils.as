package suity.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author simage
	 */
	public class EventUtils 
	{
		public static function OnMouseDown($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_DOWN, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_DOWN, $listener);
			}
		}
		public static function OnMouseUp($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_UP, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_UP, $listener);
			}
		}
		public static function OnMouseMove($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_MOVE, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_MOVE, $listener);
			}
		}
		public static function OnMouseOver($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_OVER, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_OVER, $listener);
			}
		}
		public static function OnMouseOut($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_OUT, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_OUT, $listener);
			}
		}
		public static function OnMouseWheel($dispacher:EventDispatcher, $listener:Function, $switch:Boolean):void {
			if ($switch) {
				$dispacher.addEventListener(MouseEvent.MOUSE_WHEEL, $listener);
			} else {
				$dispacher.removeEventListener(MouseEvent.MOUSE_WHEEL, $listener);
			}
		}
		
	}
	
}