package suity.utils 
{
	/**
	 * ...
	 * @author Simage
	 */
	public class DepthTrace
	{
		private static var NewLine:String = "\r\n";
		
		public static function Trace($obj:*, $limit:int = -1):void {
			//trace(GetInfo($obj, 0, $limit));
		}
		
		public static function GetInfo($obj:*, $indent:int = 0, $limit:int = -1):String {
			if ($obj is Array) {
				return GetArrayInfo($obj as Array, $indent, $limit);
			} else if ($obj is Boolean || $obj is int || $obj is uint || $obj is Number) {
				return GetValue($obj);
			} else if ($obj is String) {
				return GetString(String($obj));
			} else {
				return GetObjectInfo(Object($obj), $indent, $limit);
			}
		}
		
		private static function GetValue($value:*):String {
			return String($value);
		}
		private static function GetString($str:String):String{
			return "\"" + $str + "\"";
		}
		private static function GetObjectInfo($obj:Object, $indent:int, $limit:int):String {
			var $space2:String = GetSpace($indent);
			var $space:String = GetSpace($indent + 1);
			var $info:String = ClassUtils.GetClassName($obj) + " {" + NewLine;
			
			if ($limit < 0 || $limit >= $indent) {
				for (var $name:String in $obj) {
					$info += $space + $name + " : " + GetInfo($obj[$name], $indent + 1, $limit) + NewLine;
				}
			} else {
				$info += $space + "(+)" + NewLine;
			}
			
			$info += $space2 + "}" + NewLine;
			return $info;
		}
		private static function GetArrayInfo($ary:Array, $indent:int, $limit:int):String {
			var $space2:String = GetSpace($indent);
			var $space:String = GetSpace($indent + 1);
			var $info:String = "Array [" + NewLine;
			
			if ($limit < 0 || $limit >= $indent) {
				for (var i:* in $ary) {
					$info += $space + i + " : " + GetInfo($ary[i], $indent + 1, $limit) + NewLine;
				}
			} else {
				$info += $space + "(+)" + NewLine;
			}
				
			$info += $space2 + "]" + NewLine;
			return $info;
		}
		private static function GetSpace($indent:int):String {
			var $space:String = "";
			for (var i:int = 0; i < $indent; i++) {
				$space += "  ";
			}
			return $space;
		}
		
		
		public static function Merge($from:*, $to:*, $autoAdd:Boolean = true):* {
			if ($from is Array) {
				return MergeArray($from as Array, $to as Array, $autoAdd);
			} else if ($from is Boolean || $from is int || $from is uint || $from is Number || $from is String) {
				return $from;
			} else if ($from is Object) {
				return MergeObject($from as Object, $to as Object, $autoAdd);
			} else {
				return $from;
			}
		}
		
		private static function MergeObject($fromObj:Object, $toObj:Object, $autoAdd:Boolean):Object {
			if ($toObj == null) {
				if ($autoAdd) {
					$toObj = new Object();
				} else {
					return $toObj;
				}
			}
			for (var $key:String in $fromObj) {
				if ($toObj[$key] != null || $autoAdd) {
					//trace("merged key : " + $key + " value : " + $fromObj[$key] + " old : " + $toObj[$key]);
					$toObj[$key] = Merge($fromObj[$key], $toObj[$key], $autoAdd);
					
				}
			}
			return $toObj;
		}
		private static function MergeArray($fromArray:Array, $toArray:Array, $autoAdd:Boolean):Array {
			if ($toArray == null) {
				if ($autoAdd) {
					$toArray = new Array();
				} else {
					return $toArray;
				}
			}
			for (var $i:* in $fromArray) {
				if ($toArray[$i] != null || $autoAdd) {
					$toArray[$i] = Merge($fromArray[$i], $toArray[$i], $autoAdd);
				}
			}
			return $toArray;
		}
		

	}

}