package suity.networking 
{
	import suity.sim.SimMsgType;
	import suity.sim.core.impl.SimComponent;
	import suity.sim.SimMessage;
	import suity.sim.SimEvent;
	import suity.utils.StringUtils;
	/**
	 * ...
	 * @author Simage
	 */
	public class SimEventClientComponent extends SimComponent implements IClientDataHandler
	{
		private var handler:SimEventHandlerBundle = new SimEventHandlerBundle();
		protected function get Handler():SimEventHandlerBundle { return handler; }
		
		private var doDispatch:Boolean = true;
		/**
		 * 是否在完成调用后自动发送转发信息，通过设置false，可以自定义转发的顺序，避免删除操作的顺序错误
		 */
		protected var PostDispatch:Boolean;
		
		protected var DispatchMsg:String;
		protected var RegisterID:int;
		
		public function SimEventClientComponent($registerID:int, $dispatchMsg:String = null) {
			DispatchMsg = $dispatchMsg;
			RegisterID = $registerID;
			doDispatch = !StringUtils.IsNullOrEmpty($dispatchMsg);
		}
		
		override protected function OnInitSimComponent():void {
			super.OnInitSimComponent();
			AddMessageListenerFunc(SimMsgType.MsgPreBoot, CommandPreBoot);
			PostDispatch = doDispatch;
		}
		
		public function HandlePacket($sender:ClientSession, $packet:DataPacket):void {
			var $event:SimEvent = $sender.GetSimEventDown($packet);
			handler.HandleDirect($event);
			if (PostDispatch) {
				SendMessage(DispatchMsg, $event);
			} else {
				PostDispatch = doDispatch;
			}
		}
		
		protected function CommandPreBoot($msg:SimMessage):void {
			SendMessage(ClientSession.MsgRegisterHandler, RegisterID);
		}
		protected function DispatchSimEvent($event:SimEvent):void {
			SendMessage(DispatchMsg, $event);
		}
		
	}

}