package suity.utils 
{
	/**
	 * ...
	 * @author simage
	 */
	public class BooleanUtils 
	{
		public static function GetBoolean($str:String):Boolean {
			$str = $str.toLowerCase();
			if ($str == "false" || $str == "0") {
				return false;
			} else {
				return true;
			}
		}
		
	}

}