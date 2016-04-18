package suity.utils 
{
	import flash.xml.XMLNode;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class XmlUtils 
	{
		public static function GetBoolean($xml:XML, $name:String, $default:Boolean = false):Boolean {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return $str == "true";
			} else {
				return $default;
			}
		}
		public static function GetByte($xml:XML, $name:String, $default:int = 0):int {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return int($str);
			} else {
				return $default;
			}
		}
		public static function GetInt16($xml:XML, $name:String, $default:int = 0):int {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return int($str);
			} else {
				return $default;
			}
		}
		public static function GetUInt16($xml:XML, $name:String, $default:int = 0):int {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return int($str);
			} else {
				return $default;
			}
		}
		public static function GetInt32($xml:XML, $name:String, $default:int = 0):int {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return int($str);
			} else {
				return $default;
			}
		}
		public static function GetUInt32($xml:XML, $name:String, $default:uint = 0):uint {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return uint($str);
			} else {
				return $default;
			}
		}
		public static function GetNumber($xml:XML, $name:String, $default:Number = 0):Number {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return Number($str);
			} else {
				return $default;
			}
		}
		public static function GetSingle($xml:XML, $name:String, $default:Number = 0):Number {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return Number($str);
			} else {
				return $default;
			}
		}
		public static function GetDouble($xml:XML, $name:String, $default:Number = 0):Number {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return Number($str);
			} else {
				return $default;
			}
		}
		public static function GetString($xml:XML, $name:String, $default:String = null):String {
			var $str:String = $xml[$name][0];
			if (!StringUtils.IsNullOrEmpty($str)) {
				return $str;
			} else {
				return $default;
			}
		}
		
		public static function GetValueThrow($xml:XML, $name:String):* {
			var $value:XMLList = $xml[$name][0];
			if ($value[0] == null) {
				//trace("WARNING : Xml node not found : " + $name);
				throw new Error("Xml node not found : " + $name);
				return $value;
			}
			return $value;
		}
	}
	
}