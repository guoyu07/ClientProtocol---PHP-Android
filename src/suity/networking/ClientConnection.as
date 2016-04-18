package suity.networking
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.*;
	import com.hurlant.util.Base64;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import tweener.fl9.Tweener;
	
	/**
	 * ...
	 * @author Simage
	 */
	// 客户端连接
	public class ClientConnection 
	{
		private var sock:Socket;
		// 是否已连接
		public function get IsConnected():Boolean { return sock.connected; }

		private var encryption:ICipher = null;
		// 是否加密数据
		public function get Encryption():ICipher { return encryption; }
		
		// 是否压缩数据
		public var DoCompress:Boolean = false;
		
		public var EndianMode:String;
		
		private var connectCallBack:Function;
		private var closeCallBack:Function;
		private var errorCallBack:Function;
		private var packetCallBack:Function;
		
		public function ClientConnection($endian:String = Endian.LITTLE_ENDIAN) {
			EndianMode = $endian;
			
			sock = new Socket();
			sock.endian = EndianMode;
			sock.addEventListener(Event.CLOSE, closeHandler);
			sock.addEventListener(Event.CONNECT, connectHandler);
			sock.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			sock.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		// 关闭连接
		public function Close():void 
		{
			sock.close();
			tryByteCallBack = null;
			tryByteCount = 0;
			packet = null;
		}

		// 只可以Config一次的机制
		private var isCallBackConfig:Boolean = false;
		// 挂接事件
		public function ConfigCallBack($connectCallBack:Function, $closeCallBack:Function, $errorCallBack:Function, $packetCallBack:Function):void {
			if (isCallBackConfig) throw new Error();
			connectCallBack = $connectCallBack;
			closeCallBack = $closeCallBack;
			errorCallBack = $errorCallBack;
			packetCallBack = $packetCallBack;
			isCallBackConfig = true;
		}
		
		// 设置密匙
		public function SetEncryption($algorithName:String, $keyBase64:String, $ivBase64:String):void 
		{
			if ($algorithName == "Rijndael") $algorithName = "AES";
			
			var $key:ByteArray = Base64.decodeToByteArray($keyBase64);
			var $iv:ByteArray = Base64.decodeToByteArray($ivBase64);
			
			var $fullName:String = $algorithName + "-CBC";
			$fullName = $fullName.toLowerCase();
			
			var $pad:IPad = new PKCS5();
			encryption = Crypto.getCipher($fullName, $key, $pad);
			
			if (encryption == null) throw new Error("Encryption not found : " + $fullName);
		
			$pad.setBlockSize(encryption.getBlockSize());
			
			var $ivMode:IVMode = encryption as IVMode;
			if ($ivMode != null) {
				$ivMode.IV = $iv;
			}
		}
		
		// 连接
		public function Connect($host:String, $port:int):void {
			//trace("connecting to : " + $host + ":" + $port);
			sock.connect($host, $port);
		}
		public function Disconnect():void {
			try {
				if (sock.connected) sock.close();
			} catch ($e:Error) {
			}
		}
		
		// 发送数据
		public function SendData($serviceID:int, $serviceCode:int, $data:ByteArray, $encryptData:Boolean = false):void {
			var $packet:DataPacket = new DataPacket();
			$packet.PrimaryCode = $serviceID;
			$packet.SecondaryCode = $serviceCode;
			$packet.Data = $data;
			
			PreparePacket($packet);
			$packet.DataSize = $packet.Data.length;
			
			//trace("Send : " + $packet.DataSize);
			SendPacket($packet);
		}
		private function SendPacket($packet:DataPacket):void 
		{
			sock.writeByte($packet.Flags);
			sock.writeByte($packet.PrimaryCode);
			sock.writeByte($packet.SecondaryCode);
			sock.writeInt($packet.DataSize);
			sock.writeBytes($packet.Data, 0, $packet.Data.length);
			sock.flush();
		}
		
		////////////////////////////////////////////////////////////////////////////
		// 异步接受数据机制
		private var tryByteCallBack:Function = null;
		private var tryByteCount:uint = 0;

		private function Receive($byteCount:uint, $callBack:Function):void {
			if ($byteCount == 0) throw new Error("byte 0 byte");
			if ($callBack == null) throw new Error("callback is null");
			
			tryByteCallBack = $callBack;
			tryByteCount = $byteCount;
			
			//TryGetBytes();
		}
		private function TryGetBytes():void {
			if (tryByteCount == 0) return;
			if (!sock.connected) return;
			while (tryByteCount <= sock.bytesAvailable) {
				var $b:ByteArray = new ByteArray();
				$b.endian = EndianMode;
				sock.readBytes($b, 0, tryByteCount);
				tryByteCount = 0;
				tryByteCallBack($b);
			}
		}
		////////////////////////////////////////////////////////////////////////////
		// packet 处理 
		private var packet:DataPacket;
		
		private function OnReceivePacketHeader($b:ByteArray):void {
			packet = new DataPacket();
			packet.Flags = $b.readUnsignedByte();
			packet.PrimaryCode = $b.readUnsignedByte();
			packet.SecondaryCode = $b.readUnsignedByte();
			packet.DataSize = $b.readInt();
			//trace("Create Packet Header : " + packet.toString());
			if (packet.DataSize == 0) {
				packet.Data = new ByteArray();
				OnPacketOK();
			} else {
				Receive(packet.DataSize, OnReceivePacketBody);
			}
		}
		
		private function OnReceivePacketBody($b:ByteArray):void {
			if (packet.DataSize != $b.length) throw new Error("packet data length mismatch " + packet.DataSize + ":" + $b.length);
			
			packet.Data = $b;
			//trace("Get Packet Content : " + RPCFormatter.TraceByteArray($b));
			UnPreparePacket(packet);
			OnPacketOK();
		}
		
		private function PreparePacket($packet:DataPacket):void {
			if ($packet.Data == null) return;
			
			if ((($packet.Flags | DataPacket.FlagEncrypted) == $packet.Flags) && encryption != null) {
				encryption.encrypt($packet.Data);
			}
			
			if (($packet.Flags | DataPacket.FlagCompressed) == $packet.Flags) {
				$packet.Data.compress();
			}
		}
		private function UnPreparePacket($packet:DataPacket):void {
			if ($packet.Data == null) return;
			
			if (($packet.Flags | DataPacket.FlagCompressed) == $packet.Flags) {
				$packet.Data.uncompress();
			}
			
			if ((($packet.Flags | DataPacket.FlagEncrypted) == $packet.Flags) && encryption != null) {
				encryption.decrypt($packet.Data);
			}
		}
		
		private function OnPacketOK():void {
			var $packet:DataPacket = packet;
			packet = null;
			
			if (packetCallBack != null) {
				packetCallBack(this, $packet);
			}
			Receive(7, OnReceivePacketHeader);
		}
		
		////////////////////////////////////////////////////////////////////////////
		// sock 响应
		
		private function closeHandler(event:Event):void {
			//trace("closeHandler: " + event);
			if (closeCallBack != null) closeCallBack(this);
		}

		private function connectHandler(event:Event):void {
			//trace("connectHandler: " + event);
			if (connectCallBack != null) connectCallBack(this);
			Receive(7, OnReceivePacketHeader);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			//trace("ioErrorHandler: " + event);
			if (errorCallBack != null) errorCallBack(this);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			//trace("securityErrorHandler: " + event);
			if (errorCallBack != null) errorCallBack(this);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			//trace("socketDataHandler: " + event);
			TryGetBytes();
		}
		
	}
	
}