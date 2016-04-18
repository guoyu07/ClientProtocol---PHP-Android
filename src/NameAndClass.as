package  
{
	import suity.utils.StringUtils;
	/**
	 * ...
	 * @author 不再迟疑
	 */
	public class NameAndClass 
	{
		private var _name:String;
		public var className:String;
		public var url:String;
		public var desc:String;
		public var value:String;
		public var resp:String;
		public var annotation:String;
		private static var varsToClass:Object = new Object();
		public static function init():void
		{
			varsToClass["Boolean"] = "Boolean";
			varsToClass["boolean"] = "Boolean";
			varsToClass["int"] = "int";
			varsToClass["int32"] = "int";
			varsToClass["Int32"] = "int";
			varsToClass["Int"] = "int";
			varsToClass["string"] = "String";
			varsToClass["String"] = "String";
		}
		public function NameAndClass($name:String, $className:String, $url:String,$resp:String, $desc:String, $value:String, $annotation:String) 
		{
			this._name = $name;
			this.className = $className;
			this.url = $url;
			this.desc = $desc;			
			this.value = $value;		
			this.resp = $resp;
			this.annotation = $annotation;	
		}
		
		public function getClass():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = className;
			}			
			return tempName;
		}
		public function getClassFormate():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = className;
			}
			return tempName;
		}
		
		public function formate():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = className;
			}else
			{
				tempName = "DataFormate";
			}
			return tempName;
		}
		
		public function get name():String 
		{
			var str:String = _name.charAt(0).toLocaleLowerCase();
			return str + _name.substring(1);
		}
		
		public function get mname():String 
		{
			return _name.toLocaleUpperCase();
		}
		public function get mvalue():String 
		{
			if (getClass() == "String")
			{
				return '"' + value+'"';
			}else {
				return value;
			}
		}
	}

}