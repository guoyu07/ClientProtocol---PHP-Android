package suity.networking 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import suity.sim.SimEvent;
	/**
	 * ...
	 * @author Simage
	 */
	public class NetSimEvent extends SimEvent
	{
		public static var DefaultEndian:String = Endian.LITTLE_ENDIAN;
		
		private static var empty:NetSimEvent = new NetSimEvent();
		public static function get Empty():NetSimEvent { return empty; }
		
		
		public function NetSimEvent() {
		}
		
		override public function WriteByteArray($b:ByteArray):void {
			//TODO: 新的封装方法不再拆开ID和数据，而且Type和ID都会写入
			$b.writeByte(0);
		}
		public function GetByteArray():ByteArray {
			var $b:ByteArray = new ByteArray();
			$b.endian = DefaultEndian;
			WriteByteArray($b);
			return $b;
		}
		public function GetObject():Object {
			throw new Error("Not implemented");
		}
		//public function SendSession($session:ClientSession):void {
		//	var $b:ByteArray = new ByteArray();
		//	$b.endian = Endian.LITTLE_ENDIAN;
		//	WriteByteArray($b, false);
		//	$session.SendData(EventType, EventID, $b);
		//}
	
	}

}