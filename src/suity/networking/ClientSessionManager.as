package suity.networking 
{
	import suity.collection.nonil.LookUpListNN;
	import suity.sim.core.support.SimComponent;
	import suity.sim.SimMessage;
	import suity.sim.SimEvent;
	/**
	 * ...
	 * @author Simage
	 */
	public class ClientSessionManager extends SimComponent
	{
		private var networkConfig:ClientNetworkConfig;
		
		private var sessions:LookUpListNN = new LookUpListNN(GetSessionKey);
		private function GetSessionKey($session:ClientSession):String { return $session.ConnectionString; }
		
		private var mainSession:ClientSession;
		public function get MainSession():ClientSession { return mainSession; }
		public function set MainSession($value:ClientSession):void { mainSession = $value; }

		private var dataHandlers:Array = new Array();
		private var defaultPacketCallBack:Function;
		// 供ClientSession使用
		internal var simEventReadersDn:Array = new Array();
		internal var simEventReadersUp:Array = new Array();
		
		public function ClientSessionManager($networkConfig:ClientNetworkConfig) {
			if ($networkConfig == null) throw new Error();
			networkConfig = $networkConfig;
		}
		
		override protected function OnInitSimComponent():void {
			super.OnInitSimComponent();
			AddMessageListenerFunc(ClientSession.MsgRegisterHandler, CommandRegisterDefaultHandler);
		}
		private function CommandRegisterDefaultHandler($msg:SimMessage):void {
			RegisterDefaultHandler($msg.Sender as IClientDataHandler, $msg.Content as int);
		}

		
		
		// 挂接默认数据事件
		public function ConfigDefaultDataCallBack($defaultPacketCallBack:Function = null):void {
			defaultPacketCallBack = $defaultPacketCallBack;
		}
		// 添加SimEvent解析器, 用于将DataPacket解析成SimEvent
		public function SetSimEventPacketReader($serviceID:int, $reader:Function):void {
			if (simEventReadersUp[$serviceID] != null) throw new Error("SimEvent packet reader(upload) already exist : " + $serviceID);
			simEventReadersUp[$serviceID] = $reader;
		}
		public function SetSimEventPacketReaderServer($serviceID:int, $reader:Function):void {
			return SetSimEventPacketReader($serviceID, $reader);
		}
		public function SetSimEventPacketReaderClient($serviceID:int, $reader:Function):void {
			if (simEventReadersDn[$serviceID] != null) throw new Error("SimEvent packet reader(download) already exist : " + $serviceID);
			simEventReadersDn[$serviceID] = $reader;
		}
		
		// 确保会话存在
		public function EnsureSession($host:String, $port:int):ClientSession {
			if (!MyBody.IsInitialized) throw new Error("Host not start");
			
			var $session:ClientSession = GetSession($host, $port);
			if ($session == null) {
				$session = new ClientSession($host, $port, networkConfig);
				$session.InitSessionManager(this);
				$session.ConfigDefaultDataCallBack(OnSessionPacket);
				sessions.Add($session);
			}
			return $session;
		}
		
		// 获取会话
		public function GetSession($host:String, $port:int, $mustConnected:Boolean = false):ClientSession {
			if (!MyBody.IsInitialized) throw new Error("Host not yet init");
			
			var $connStr:String = $host + ":" + $port;
			var $session:ClientSession = sessions.GetItemByID($connStr) as ClientSession;
			if (!$mustConnected || $session.IsConnected) {
				return $session;
			} else {
				return null;
			}
		}
		
		// 关闭会话
		public function CloseSession($host:String, $port:int):void {
			if (!MyBody.IsInitialized) throw new Error("Host not yet init");
			
			var $session:ClientSession = GetSession($host, $port);
			if ($session != null) {
				$session.ConfigDefaultDataCallBack();
				$session.Connection.Close();
				sessions.Remove($session);
			}
		}
		
		// 删除全部会话
		public function Reset():void {
			//trace("ClientSessionManager : Reset");
			
			for (var i:int = 0; i < sessions.Count; i++) {
				var $session:ClientSession = sessions.GetItem(i) as ClientSession;
				$session.Disconnect();
			}
			sessions.Clear();
		}
		
		private function OnSessionPacket($session:ClientSession, $packet:DataPacket):void {
			var $handler:IClientDataHandler = dataHandlers[$packet.PrimaryCode] as IClientDataHandler;
			if ($handler != null) {
				// 找到响应器
				$handler.HandlePacket($session, $packet);
			} else if (defaultPacketCallBack != null) {
				// 没有找到，发出事件
				defaultPacketCallBack(this, $packet);
			}
		}
		
		// 注册响应器
		public function RegisterDefaultHandler($handler:IClientDataHandler, $serviceID:int):void {
			if ($handler == null) throw new Error();
			if ($serviceID <= 0) throw new Error("zero handler id");
			
			var $exist:IClientDataHandler = dataHandlers[$serviceID] as IClientDataHandler;
			if ($exist != null && $exist != $handler) {
				throw new Error("handler collide " + $exist + " : " + $handler + " : " + $serviceID);
			}
			dataHandlers[$serviceID] = $handler;
		}
		// 注销响应器
		public function UnregisterDefaultHandler($handler:IClientDataHandler, $serviceID:int):void {
			if ($handler == null) throw new Error();
			if ($serviceID <= 0) throw new Error("zero handler id");
			
			if (dataHandlers[$serviceID] != $handler) throw new Error("handler collide");
			delete dataHandlers[$serviceID];
		}
		
	}

}