package suity.networking 
{
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author Simage
	 */
	public class ClientNetworkConfig 
	{
		public var EndianMode:String = Endian.LITTLE_ENDIAN;
		public var DoCompress:Boolean = false;
		public var EncryptionAgorithm:String = "Rijndael";
		public var EncryptionKey:String = "T6AkG6vn+lkrJMs/zLEE5QpIzd+0mp06P96e3nliKWE=";
		public var EncryptionIV:String = "ZOWT8YvIgxvov0jZbc8XIw==";
		public var CompressFlag:String = CompressionAlgorithm.ZLIB;
	}
	
}