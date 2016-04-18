package suity.networking 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class IPEndPoint 
	{
		private var address:IPAddress;
		public function get Address():IPAddress { return address; }
		
		private var port:int;
		public function get Port():int { return port; }
		
		public function IPEndPoint($b1:int, $b2:int, $b3:int, $b4:int, $port:int) {
			address = new IPAddress($b1, $b2, $b3, $b4);
			port = $port;
		}
		
		public function Write($b:ByteArray):void 
		{
			address.Write($b);
			$b.writeShort(port);
		}
		public function toString():String 
		{
			return address.toString() + ":" + port;
		}
		
		
		public static function FromAddress($ipString:String, $port:int):IPEndPoint {
			var $split:Array = $ipString.split(".", 4);
			return new IPEndPoint(int($split[0]), int($split[1]), int($split[2]), int($split[3]), $port);
		}
		public static function FromByteArray($b:ByteArray):IPEndPoint 
		{
			return new IPEndPoint($b.readUnsignedByte(), $b.readUnsignedByte(), $b.readUnsignedByte(), $b.readUnsignedByte(), $b.readUnsignedShort());
		}
		
	}
	
}