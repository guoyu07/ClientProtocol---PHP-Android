package suity.networking 
{
	import flash.utils.ByteArray;
	
	public class RawDate 
	{
		public var Year:int;
		public var Month:int;
		public var Day:int;
		
		public function Write($b:ByteArray):void 
		{
			$b.writeShort(Year);
			$b.writeByte(Month);
			$b.writeByte(Day);
		}
		
		public function Read($b:ByteArray):void 
		{
			Year = $b.readUnsignedShort();
			Month = $b.readUnsignedByte();
			Day = $b.readUnsignedByte();
		}
		
		public function toString():String 
		{
			return Year + "/" + Month + "/" + Day;
		}
		
		public static function FromByteArray($b:ByteArray):RawDate {
			var $date:RawDate = new RawDate();
			$date.Read($b);
			return $date;
		}
		
	}
	
}