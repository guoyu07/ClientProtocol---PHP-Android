package suity.utils 
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.IHash;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class HashUtils 
	{
		private static var hash:IHash = Crypto.getHash("sha256");
		
		public static function HashByteArray($src:ByteArray):ByteArray {
			return hash.hash($src);
		}

		public static function Hash2ByteArray($src1:ByteArray, $src2:ByteArray):ByteArray {
			return hash.hash(CombineByteArray($src1, $src2));
		}

		public static function CombineByteArray($src1:ByteArray, $src2:ByteArray):ByteArray {
			var $src:ByteArray = new ByteArray();
			$src.writeBytes($src1, 0, $src1.length);
			$src.writeBytes($src2, 0, $src2.length);
			return $src;
		}
		
		public static function HashString($src:String):ByteArray {
			return hash.hash(Hex.toArray(Hex.fromString($src)));
		}

		public static function HashByteString($src1:ByteArray, $src2:String):ByteArray {
			return Hash2ByteArray($src1, Hex.toArray(Hex.fromString($src2)));
		}
		
		public static function HashStringByte($src1:String, $src2:ByteArray):ByteArray {
			return Hash2ByteArray(Hex.toArray(Hex.fromString($src1)), $src2);
		}

		public static function HashStringBase64($src1:String, $base64Src:String):ByteArray {
			return Hash2ByteArray(Hex.toArray(Hex.fromString($src1)), Base64.decodeToByteArray($base64Src));
		}

		public static function HashBase64String($base64Src:String, $src2:String):ByteArray {
			return Hash2ByteArray(Base64.decodeToByteArray($base64Src), Hex.toArray(Hex.fromString($src2)));
		}

		public static function StringToByteArray($src:String):ByteArray {
			return Hex.toArray(Hex.fromString($src));
		}
		
		public static function GetBytesString($b:ByteArray):String {
			var $str:String = "";
			for (var i:int = 0; i < $b.length; i++) {
				$str += String($b[i]) + " ";
			}
			return $str;
		}
	}

}