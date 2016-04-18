package suity.networking 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class RawDateTime 
	{
		public var Year:int;
		public var Month:int;
		public var Day:int;
		public var Hour:int;
		public var Minute:int;
		public var Second:int;
		
		public function Write($b:ByteArray):void 
		{
			$b.writeShort(Year);
			$b.writeByte(Month);
			$b.writeByte(Day);
			$b.writeByte(Hour);
			$b.writeByte(Minute);
			$b.writeByte(Second);
		}
		
		public function Read($b:ByteArray):void 
		{
			Year = $b.readUnsignedShort();
			Month = $b.readUnsignedByte();
			Day = $b.readUnsignedByte();
			Hour = $b.readUnsignedByte();
			Minute = $b.readUnsignedByte();
			Second = $b.readUnsignedByte();
		}
				
		public function toString():String 
		{
			return Year + "/" + Month + "/" + Day + " " + Hour + ":" + Minute + ":" + Second;
		}
		
		public static function FromByteArray($b:ByteArray):RawDateTime {
			var $dateTime:RawDateTime = new RawDateTime();
			$dateTime.Read($b);
			return $dateTime;
		}
		
	}
	
}