package suity.networking 
{
	
	/**
	 * ...
	 * @author Simage
	 */
	public interface IClientService 
	{
		//function get Name():String;
		function Initialize($host:ClientNetworkHost):void;
		function Reset():void;
	}
	
}