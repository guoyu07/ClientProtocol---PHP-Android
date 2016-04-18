package suity.utils 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class InteractiveUtils 
	{
		
		public static function SetUseHandCursor($display:DisplayObject, $use:Boolean):void {
			if ($display is Sprite) {
				Sprite($display).useHandCursor = $use;
			} else if ($display is SimpleButton) {
				SimpleButton($display).useHandCursor = $use;
			}
		}
		
	}
	
}