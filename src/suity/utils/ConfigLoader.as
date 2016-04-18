package suity.utils 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author weeky
	 */
	public class ConfigLoader
	{
		public static const State_Unloaded:int = 0;
		public static const State_Loading:int = 1;
		public static const State_Finish:int = 2;
		public static const State_Failed:int = 3;

		public static const Mode_Loader:String = "Loader";
		public static const Mode_URLLoader:String = "URLLoader";
		
		public static const Domain_CurrentDomain:int = 0;
		public static const Domain_ChildDomain:int = 1;
		
		// 地址
		private var myRequest:URLRequest;

		// 模式 : Loader | URLLoader
		private var mode:String;
		public function get Mode():String { return mode; }

		// 创建的Loader
		private var myLoader:EventDispatcher;
		
		// 域加载方法
		private var domain:ApplicationDomain;
		
		// 当前loading状态
		private var state:int = State_Unloaded;
		public function get State():int { return state; }

		// 加载完结果，如果是Loader,他就是Loader, 如果是UrlLoader，他就是UrlLoader.Data
		private var data:Object;
		
		// 事件挂接
		private var hookLoadProgress:Function;
		private var hookLoadResult:Function;
		
		public function ConfigLoader($str_url:String) {
			if ($str_url == null || $str_url == "") throw new Error();
			
			myRequest = new URLRequest($str_url);
			
			var $str:String = $str_url.substring($str_url.length - 3, $str_url.length).toLowerCase();
			if ($str == "jpg" || $str == "png" || $str == "gif" || $str == "swf") {
				var $loader:Loader = new Loader();
				mode = Mode_Loader;
				myLoader = $loader;
				RegEvents($loader.contentLoaderInfo);
			} else if ($str == "xml" || $str == "txt") {
				mode = Mode_URLLoader;
				var $urlLoader:URLLoader = new URLLoader();
				myLoader = $urlLoader;
				RegEvents($urlLoader);
			} else {
				throw new Error();
			}
			state = State_Unloaded;
		}
		
		public function ConfigCallBack($loadResult:Function = null, $loadProgress:Function = null):void {
			hookLoadResult = $loadResult;
			hookLoadProgress = $loadProgress;
		}
		
		public function SetDomain($domain:ApplicationDomain):void {
			if (mode != Mode_Loader) throw new Error();
			if ($domain == null) throw new Error();
			if (domain != null) throw new Error();
			
			domain = $domain;
		}
		
		public function Load():void {
			if (state == State_Loading) throw new Error();
			
			if (mode == Mode_Loader) {
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = domain;
				context.checkPolicyFile = false;
				Loader(myLoader).load(myRequest);
			} else if (mode == Mode_URLLoader) {
				URLLoader(myLoader).load(myRequest);
			}
		}
		
		public function Unload():void {
			if (mode == Mode_Loader) {
				var $loader:Loader = Loader(myLoader);
				if ($loader.loaderInfo != null) {
					$loader.close();
					//trace("ConfigLoader : " + myRequest.url + " closed");
				}
				try {
					$loader.unload();
					//trace("ConfigLoader : " + myRequest.url + " unloaded");
				} catch ($e1:Error) {
				}
				
			} else if (mode == Mode_URLLoader) {
				var $urlLoader:URLLoader = URLLoader(myLoader);
				try {
					$urlLoader.close();
					trace("ConfigLoader : " + myRequest.url + " closed");
				} catch ($e2:Error) {
				}
			}
		}
		
		private function RegEvents($listenr:EventDispatcher):void {
			$listenr.addEventListener(Event.COMPLETE, handlerComplete);
			$listenr.addEventListener(Event.OPEN, handlerOpen);
			$listenr.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
			$listenr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerSecurity);
			$listenr.addEventListener(HTTPStatusEvent.HTTP_STATUS, handlerHttpStatus);
			$listenr.addEventListener(IOErrorEvent.IO_ERROR, handlerIoError);
		}
		private function UnregEvents($listenr:EventDispatcher):void {
			$listenr.removeEventListener(Event.OPEN, handlerOpen);
			$listenr.removeEventListener(Event.COMPLETE, handlerComplete);
			$listenr.removeEventListener(ProgressEvent.PROGRESS, handlerProgress);
			$listenr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerSecurity);
			$listenr.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handlerHttpStatus);
			$listenr.removeEventListener(IOErrorEvent.IO_ERROR, handlerIoError);
		}
		
		
		// 获取XML
		public function get Data():Object { return data; }
		public function CastLoader():Loader {
			return Loader(data);
		}
		
		// 返回
		private function DoCallback($status:Boolean):void {
			if (hookLoadResult != null) hookLoadResult(this);
		}
		// 开始加载
		private function handlerOpen($evt:Event):void {
			//trace("handlerOpen: " + event);
			state = State_Finish;
		}
		// 加载
		private function handlerComplete($evt:Event):void	{
			if (myLoader is Loader) {
				var $loader:Loader = Loader(myLoader);
				data = $loader;
			} else if (myLoader is URLLoader) {
				var $urlLoader:URLLoader = URLLoader(myLoader);
				data = $urlLoader.data;
			} else {
				throw new Error(myLoader);
			}
			
			state = State_Finish;
			if (hookLoadResult != null) hookLoadResult(this);
		}
		// 加载进度
		private function handlerProgress($evt:ProgressEvent):void {
			state = State_Loading;
			if (hookLoadProgress != null) hookLoadProgress(this, $evt.bytesLoaded, $evt.bytesTotal);
			//trace("handlerProgress loaded:" + $evt.bytesLoaded + " total: " + $evt.bytesTotal);
		}
		
		private function handlerSecurity($evt:SecurityErrorEvent):void {
			DoCallback(false);
			state = State_Failed;
		}
		
		private function handlerHttpStatus($evt:HTTPStatusEvent):void {
			//trace("handlerHttpStatus: " + $evt);
			// FUTURE: Need to inspect HTTP status events for failure?
			state = State_Failed;
		}
		// 如果发生错误并导致发送或加载操作失败
		private function handlerIoError($evt:IOErrorEvent):void {
			//trace("!!!!!!!!! Load Failed : " + strUrl);
			DoCallback(false);
			state = State_Failed;
		}
	}
	
}