package suity.utils 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Simage
	 */
	public class ClassUtils 
	{
		public static function GetClass($obj:Object):Class{
			var $name:String = getQualifiedClassName($obj);
			return getDefinitionByName($name) as Class;
		}
		public static function GetClassByName($name:String):Class{
			return getDefinitionByName($name) as Class;
		}
		public static function CreateInstanceByName($name:String):Object {
			var $cls:Class = GetClassByName($name);
			if ($cls != null) {
				return new $cls();
			} else {
				return null;
			}
		}
		public static function GetClassName($obj:*):String {
			return getQualifiedClassName($obj);
		}
		public static function GetShortClassName($obj:*):String {
			var $fullName:String = getQualifiedClassName($obj);
			var $ary:Array = $fullName.split("::");
			return $ary[$ary.length -1];
		}
	}
	
}