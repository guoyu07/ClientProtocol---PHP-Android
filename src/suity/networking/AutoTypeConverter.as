package suity.networking 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class AutoTypeConverter 
	{
		private var _id:int;
		private var _reader:Function;
		private var _writer:Function;
		
		public function get ID():int { return _id; }
		
		public function AutoTypeConverter($id:int, $reader:Function, $writer:Function) {
			if ($reader == null || $writer == null) throw new Error();
			_id = $id;
			_reader = $reader;
			_writer = $writer;
		}
		
		public function Read($b:ByteArray):Object {
			return _reader($b);
		}
		public function Write($b:ByteArray, $obj:Object):void {
			_writer($b, $obj);
		}
		
	}

}