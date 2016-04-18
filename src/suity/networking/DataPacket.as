package suity.networking
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class DataPacket 
	{
		public static const FlagConnectionRelated:int = 128;
		public static const FlagEncrypted:int = 64;
		public static const FlagCompressed:int = 32;
		public static const FlagNone:int = 0;
		
		
		public var Flags:int;
		
		public var PrimaryCode:int;
		
		public var SecondaryCode:int;
		
		public var DataSize:int;
		
		public var Data:ByteArray;
		
		public function DataPacket() {}
	
		
		public function toString():String {
			return "Flags:" + Flags + " PrimaryCode:" + PrimaryCode + " SecondaryCode" + SecondaryCode + " DataSize:" + DataSize;
		}
	}
	
}