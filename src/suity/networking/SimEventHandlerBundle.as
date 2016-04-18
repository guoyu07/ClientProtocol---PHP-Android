package suity.networking 
{
	import flash.utils.ByteArray;
	import suity.sim.SimEvent;
	import suity.utils.ILogger;
	/**
	 * ...
	 * @author Simage
	 */
	public class SimEventHandlerBundle
	{
		private var calls:Array = new Array();
		
		public function SimEventHandlerBundle() {
		}
		
		public function BindHandler($id:int, $handler:Function):void {
			calls[$id] = $handler;
		}
		
		public function HandleDirect($simEvent:SimEvent):Boolean {
			var $call:Function = calls[$simEvent.EventID];
			if ($call != null) {
				$call($simEvent);
				return true;
			} else {
				return false;
			}
		}
		public function HandleDirectContext($context:*, $simEvent:SimEvent):Boolean {
			var $call:Function = calls[$simEvent.EventID];
			if ($call != null) {
				$call($context, $simEvent);
				return true;
			} else {
				return false;
			}
			
		}
		
		public function HandleLayout($simEvent:SimEvent):Boolean {
			var $call:Function = calls[$simEvent.EventID];
			if ($call != null) {
				$simEvent.Call($call);
				return true;
			} else {
				return false;
			}
		}

	}

}