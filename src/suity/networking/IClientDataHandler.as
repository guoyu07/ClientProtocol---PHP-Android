package suity.networking 
{
	
	/**
	 * ...
	 * @author Simage
	 */
	public interface IClientDataHandler 
	{
		function HandlePacket($sender:ClientSession, $packet:DataPacket):void;
	}
	
}