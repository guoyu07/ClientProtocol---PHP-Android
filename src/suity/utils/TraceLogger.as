package suity.utils 
{
	/**
	 * ...
	 * @author Simage
	 */
	public class TraceLogger implements ILogger
	{
		private static var instance:TraceLogger = new TraceLogger();
		public static function get Instance():TraceLogger { return instance; }
		
		public function TraceLogger() {
		}
		
		public function AddLog($msg:*, $category:* = null):void {
			var $text:String;
			var $cat:String = $category == null ? null : String($category);
			if ($cat != null) {
				$text = "[" + $cat + "] " + $msg;
			} else {
				$text = $msg == null ? "" : String($msg);
				if ($text == null) $text = "";
			}
			trace($text);
		}
		
	}

}