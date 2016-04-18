package suity.utils 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class ArrayUtils 
	{
		public static function IsNullOrEmpty($array:Array):Boolean {
			return $array == null || $array.length == 0;
		}
		
		public static function CloneArray($array:Array):Array {
			if ($array == null) throw new Error();
			
			var $newAry:Array = new Array();
			for (var i:int = 0; i < $array.length; i++) {
				$newAry[i] = $array[i];
			}
			return $newAry;
		}
		
		public static function GetBytesString($b:ByteArray):String {
			var $str:String = "";
			for (var i:int = 0; i < $b.length; i++) {
				$str += String($b[i]) + " ";
			}
			return $str;
		}
		
		public static function ByteArrayEqual($b1:ByteArray, $b2:ByteArray):Boolean{
			if ($b1.length != $b2.length) return false;
			
			$b1.position = 0;
			$b2.position = 0;
			for (var i:int = 0; i < $b1.length; i++) {
				if ($b1.readByte() != $b2.readByte()) return false;
			}
			return true;
		}
		
		public static function ZeroInARow($b:ByteArray):int {
			$b.position = 0;
			var $max:int = 0;
			var $count:int = 0;
			for (var i:int = 0; i < $b.length; i++) {
				if ($b.readByte() == 0) {
					$count++;
					if ($count > $max) $max = $count;
				} else {
					$count = 0;
				}
			}
			return $max;
		}
		
		public static function Merge($ary1:Array, $ary2:Array):Array {
			var $ary:Array = new Array();
			if ($ary1 != null) {
				for (var i:int = 0; i < $ary1.length; i++) {
					$ary.push($ary1[i]);
				}
			}
			if ($ary2 != null) {
				for (var j:int = 0; j < $ary2.length; j++) {
					$ary.push($ary2[j]);
				}
			}
			return $ary;
		}
		
		public static function IndexOf($ary:Array, $value:*):int {
			for (var i:int = 0; i < $ary.length; i++) {
				if ($ary[i] == $value) return i;
			}
			return -1;
		}
		public static function LastIndexOf($ary:Array, $value:*):int {
			for (var i:int = $ary.length - 1; i >= 0; i--) {
				if ($ary[i] == $value) return i;
			}
			return -1;
		}
		
		/**
		 * 乱序数组
		 * @param	targetArr
		 * @return
		 */
		public static function RandomOrder(targetArr:Array):Array
		{
			var arrLen:int = targetArr.length;
			var tempArr1:Array = [];
			for (var i:int = 0; i < arrLen; i++) 
			{
				tempArr1[i] = i;
			}
			var tempArr2:Array = [];
			for (i = 0; i < arrLen; i++) 
			{
				tempArr2[i] = tempArr1.splice(Math.floor(Math.random() * tempArr1.length), 1);
			}
			var tempArr3:Array = [];
			for (i = 0; i < arrLen; i++) 
			{
				tempArr3[i] = targetArr[tempArr2[i]];
			}
			return tempArr3;
		}
	}
	
}