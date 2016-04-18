package suity.utils 
{
	/**
	 * ...
	 * @author °无量
	 */
	public class UInt64 
	{
		private var high:uint;
		private var low:uint;
		
		public function UInt64(high:uint,low:uint) 
		{
			this.high = high;
			this.low = low;
		}
		
		public function get High():uint { return high; }
		public function get Low():uint { return low; }
		
		public function equal(value:UInt64):Boolean {
			return value != null && this.high == value.high && this.low == value.low;
		}
		
		public function isZero():Boolean {
			return this.equal(Zero);
		}
		
		private static const zero:UInt64 = new UInt64(0, 0);
		public static function get Zero():UInt64 { return zero; }
		public static function NotEmpty(value:UInt64):Boolean { return (value != null) && !value.equal(zero); }
	}

}