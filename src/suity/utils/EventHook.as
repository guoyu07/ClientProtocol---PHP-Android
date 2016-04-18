package suity.utils 
{
	import suity.collection.nonil.ListNN;
	
	/**
	 * ...
	 * @author simage
	 */
	public class EventHook 
	{
		private var list:ListNN;
		
		public function EventHook() {
		}
		
		public function get Count():int { return list != null ? list.Count : 0; }
		public function get HasHook():Boolean { return Count > 0; }
		
		public function Add($func:Function):void {
			if (list == null) list = new ListNN();
			list.UniqueAdd($func);
		}
		
		public function Remove($func:Function):void {
			if (list == null) return;
			list.Remove($func);
			if (list.Count == 0) list = null;
		}
		
		public function Clear():void {
			list.Clear();
			list = null;
		}
		
		public function Call(...$args:Array):void {
			//if (list == null) return;
			if (list == null) throw new Error("Check HasHook before Call");
			for (var i:int = 0; i < list.Count; i++) {
				var $func:Function = list.GetItem(i) as Function;
				$func.apply(null, $args);
			}
		}
	}
	
}