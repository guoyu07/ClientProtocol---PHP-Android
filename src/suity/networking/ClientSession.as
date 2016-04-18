package suity.networking 
{
	import flash.utils.ByteArray;
	import suity.sim.SimEvent;
	import suity.utils.EventHook;
	
	/**
	 * ...
	 * @author Simage
	 */
	// 客户端会话类，管理数据包响应器
	public class ClientSession 
	{
		public static const MsgRegisterHandler:String = "__MsgRegSessionHandler";
		
		private var config:ClientNetworkConfig;
		
		// 连接
		private var connection:ClientConnection = new ClientConnection();
		public function get Connection():ClientConnection { return connection; }
		public function get IsConnected():Boolean { return connection.IsConnected; }
		
		// 地址
		private var host:String;
		public function get Host():String { return host; }
		private var port:int;
		public function get Port():int { return port; }
		public function get ConnectionString():String { return host + ":" + port; }
		// 属性挂接
		private var property:Object = new Object();
		public function get Property():Object { return property; }
		public function set Property($value:Object):void { property = $value; }

		// 连接事件
		private var eventConnected:EventHook = new EventHook();
		public function get EventConnected():EventHook { return eventConnected; }
		// 断开事件
		private var eventDisconnected:EventHook = new EventHook();
		public function get EventDisconnected():EventHook { return eventDisconnected; }
		// 出错事件
		private var eventError:EventHook = new EventHook();
		public function get EventError():EventHook { return eventError; }
		// 信号事件
		private var eventPacket:EventHook = new EventHook();
		public function get EventPacket():EventHook { return eventPacket; }
		
		// 响应器，一般不在这里设置，而在管理器中设置
		private var dataHandlers:Array = new Array();
		// 用于挂接ClientSessionManager级别的响应器
		private var defaultPacketCallBack:Function;

		
		
		public function ClientSession($host:String, $port:int, $config:ClientNetworkConfig) {
			if ($config == null) throw new Error();
			if ($host == null || $host == "") throw new Error();
			if ($port == 0) throw new Error();
			
			host = $host;
			port = $port;
			config = $config;
			
			connection.DoCompress = config.DoCompress;
			//connection.SetEncryption(config.EncryptionAgorithm, config.EncryptionKey, config.EncryptionIV);
			connection.ConfigCallBack(OnConnect, OnDisconnect, OnError, OnPacket);
		}

		
		// 注册响应器
		public function RegisterHandler($handler:IClientDataHandler, $serviceID:int):void {
			if ($handler == null) throw new Error();
			if ($serviceID <= 0) throw new Error("zero handler id");
			
			var $exist:IClientDataHandler = dataHandlers[$serviceID] as IClientDataHandler;
			if ($exist != null && $exist != $handler) {
				throw new Error("handler collide " + $exist + " : " + $handler + " : " + $serviceID);
			}
			dataHandlers[$serviceID] = $handler;
		}
		// 注销响应器
		public function UnregisterHandler($handler:IClientDataHandler, $serviceID:int):void {
			if ($handler == null) throw new Error();
			if ($serviceID <= 0) throw new Error("zero handler id");
			
			if (dataHandlers[$serviceID] != $handler) throw new Error("handler collide");
			delete dataHandlers[$serviceID];
		}
		
		
		// 连接
		public function Connect():void {
			connection.Connect(host, port);
		}
		public function Disconnect():void {
			connection.Disconnect();
		}
		// 更改连接，原来的会断开
		public function ChangeAddress($host:String, $port:int):void {
			if ($host == null || $host == "") throw new Error();
			if ($port == 0) throw new Error();
			
			connection.Disconnect();
			host = $host;
			port = $port;
		}
		
		// 发送数据
		public function SendData($serviceID:int, $serviceCode:int, $data:ByteArray, $encryptData:Boolean = false):void {
			if (!connection.IsConnected) return;
			connection.SendData($serviceID, $serviceCode, $data, $encryptData);
		}
		
		private function OnConnect($conn:ClientConnection):void {
			if (eventConnected.HasHook) eventConnected.Call(this);
		}
		private function OnDisconnect($conn:ClientConnection):void {
			if (eventDisconnected.HasHook) eventDisconnected.Call(this);
		}
		private function OnError($conn:ClientConnection):void {
			if (eventError.HasHook) eventError.Call(this);
		}
		private function OnPacket($conn:ClientConnection, $packet:DataPacket):void {
			var $handler:IClientDataHandler = dataHandlers[$packet.PrimaryCode] as IClientDataHandler;
			if ($handler != null) {
				// 找到响应器
				$handler.HandlePacket(this, $packet);
			} else if (defaultPacketCallBack != null) {
				// 没有找到，发出事件
				defaultPacketCallBack(this, $packet);
			}
			if (eventPacket.HasHook) eventPacket.Call(this, $packet);
		}
		
		public function toString():String {
			return "ClientSession[" + host + ":" + port + "]";
		}
	}
}
