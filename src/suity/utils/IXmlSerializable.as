package suity.utils
{
	import flash.xml.XMLNode;
	
	/**
	 * ...
	 * @author Simage
	 */
	public interface IXmlSerializable 
	{
		// 反串行化
		function Read($reader:XMLNode, $context:Object):void;
		// 串行化
		function Write($writer:XMLNode, $context:Object):void;
	}
	
}