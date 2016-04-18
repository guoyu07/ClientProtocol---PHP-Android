package suity.networking 
{
	import flash.utils.ByteArray;
	
	public class RawTime 
	{
		public var Hour:int;
		public var Minute:int;
		public var Second:int;
		
		public function Write($b:ByteArray):void 
		{
			$b.writeByte(Hour);
			$b.writeByte(Minute);
			$b.writeByte(Second);
		}
		
		public function Read($b:ByteArray):void 
		{
			Hour = $b.readUnsignedByte();
			Minute = $b.readUnsignedByte();
			Second = $b.readUnsignedByte();
		}
		
		public function toString():String 
		{
			return Hour + ":" + Minute + ":" + Second;
		}
		
		public static function FromByteArray($b:ByteArray):RawTime {
			var $time:RawTime = new RawTime();
			$time.Read($b);
			return $time;
		}
		
	}
	
}