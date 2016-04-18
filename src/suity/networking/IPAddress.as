package suity.networking 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class IPAddress 
	{
		private var Bytes:ByteArray;
		
		public function IPAddress($b1:int, $b2:int, $b3:int, $b4:int) {
			Bytes = new ByteArray();
			Bytes.writeByte($b1);
			Bytes.writeByte($b2);
			Bytes.writeByte($b3);
			Bytes.writeByte($b4);			
		}

		public function Write($b:ByteArray):void 
		{
			$b.writeBytes(Bytes, 0, 4);
		}
		
		public function toString():String {
			Bytes.position = 0;
			return Bytes.readUnsignedByte() + "." + Bytes.readUnsignedByte() + "." + Bytes.readUnsignedByte() + "."  + Bytes.readUnsignedByte();
		}
		
		public static function FromByteArray($b:ByteArray):IPAddress 
		{
			return new IPAddress($b.readUnsignedByte(), $b.readUnsignedByte(), $b.readUnsignedByte(), $b.readUnsignedByte());
		}
		public static function FromIPString($ipString:String):IPAddress {
			var $split:Array = $ipString.split(".", 4);
			return new IPAddress(int($split[0]), int($split[1]), int($split[2]), int($split[3]));
		}
		
	}
	
}