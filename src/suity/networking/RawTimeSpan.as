package suity.networking 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class RawTimeSpan
	{
		public var Days:int;
		public var Hours:int;
		public var Minutes:int;
		public var Seconds:int;
		
		public function Write($b:ByteArray):void 
		{
			$b.writeInt(Days);
			$b.writeByte(Hours);
			$b.writeByte(Minutes);
			$b.writeByte(Seconds);
		}
		
		public function Read($b:ByteArray):void 
		{
			Days = $b.readInt();  // 带负数
			Hours = $b.readByte();  // 带负数
			Minutes = $b.readByte();  // 带负数
			Seconds = $b.readByte();  // 带负数
		}

		public function toString():String 
		{
			return "Days:" + Days + " Hours:" + Hours + " Minutes:" + Minutes + " Seconds:" + Seconds;
		}
		
		public static function FromByteArray($b:ByteArray):RawTimeSpan {
			var $timeSpan:RawTimeSpan = new RawTimeSpan();
			$timeSpan.Read($b);
			return $timeSpan;
		}
		
	}
	
}