package suity.utils
{
	import flash.utils.getDefinitionByName;
	
	public class Activator
	{
		public static function CreateInstance($name:String):Object {
			var cls:Class = getDefinitionByName($name) as Class;
        	var obj:Object = new cls();
        	return obj;
		}
		
		public static function CreateInstanceOrNull($name:String):Object {
			var cls:Class = GetClassOrNull($name);
			if (cls != null) {
				return new cls();
			} else {
				return null;
			}
		}
		
		public static function GetClassOrNull($name:String):Class {
			try {
				var cls:Class = getDefinitionByName($name) as Class;
				return cls;
			} catch (e:Error) {
				return null;
			}
			return null;
		}
		
		public static function HasClass($name:String):Boolean {
			try {
				var cls:Class = getDefinitionByName($name) as Class;
				return cls != null;
			} catch (e:Error) {
				return false;
			}
			return false;
		}
	}
}