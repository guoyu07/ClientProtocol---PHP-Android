package suity.networking 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import suity.utils.ClassUtils;
	/**
	 * ...
	 * @author ...
	 */
	public class AutoType 
	{
		public static const TypeBoolean:int = 1;
        public static const TypeByte:int = 2;
        public static const TypeInt16:int = 3;
        public static const TypeUInt16:int = 4;
        public static const TypeInt32:int = 5;
        public static const TypeUInt32:int = 6;
        public static const TypeInt64:int = 7;
        public static const TypeUInt64:int = 8;
        public static const TypeSingle:int = 9;
        public static const TypeDouble:int = 10;
        public static const TypeString:int = 11;
		
		private static var _init:Boolean = false;
		private static var _converters:Array = new Array();
		private static var _typeLookUp:Dictionary = new Dictionary();
		
		private static function Init():void {
            RegisterConverter(Boolean, TypeBoolean, RPCFormatter.ReadBoolean, RPCFormatter.WriteBoolean);
            RegisterConverter(null, TypeByte, RPCFormatter.ReadByte, RPCFormatter.WriteByte);
            RegisterConverter(null, TypeInt16, RPCFormatter.ReadInt16, RPCFormatter.WriteInt16);
            RegisterConverter(null, TypeUInt16, RPCFormatter.ReadUInt16, RPCFormatter.WriteUInt16);
            RegisterConverter(int, TypeInt32, RPCFormatter.ReadInt32, RPCFormatter.WriteInt32);
            RegisterConverter(uint, TypeUInt32, RPCFormatter.ReadUInt32, RPCFormatter.WriteUInt32);
			RegisterConverter(null, TypeInt64, RPCFormatter.ReadInt64, RPCFormatter.WriteInt64);
            RegisterConverter(null, TypeUInt64, RPCFormatter.ReadUInt64, RPCFormatter.WriteUInt64);
            RegisterConverter(null, TypeSingle, RPCFormatter.ReadSingle, RPCFormatter.WriteSingle);
            RegisterConverter(Number, TypeDouble, RPCFormatter.ReadDouble, RPCFormatter.WriteDouble);
            RegisterConverter(String, TypeString, RPCFormatter.ReadString, RPCFormatter.WriteString);
			_init = true;
		}
		
		public static function RegisterConverter($cls:Class, $id:int, $reader:Function, $writer:Function):void {
			if ($id == 0 || $id > 255) throw new Error("id invalid : " + $id);
			if (_converters[$id] != null) throw new Error("id exist : " + $id);
			if ($reader == null || $writer == null) throw new Error();
			if ($cls != null && _typeLookUp[$cls] != null) throw new Error();
			
			var $converter:AutoTypeConverter = new AutoTypeConverter($id, $reader, $writer);
			_converters[$id] = $converter;
			if ($cls != null) _typeLookUp[$cls] = $converter;
		}
		
		public static function ReadObject($b:ByteArray):Object {
			if (!_init) Init();
			
			var $exist:int = $b.readByte();
			if ($exist == 0) return null;
			
			var $id:int = $b.readByte();
			if ($id == 0) return null;
			
			var $converter:AutoTypeConverter = _converters[$id] as AutoTypeConverter;
			if ($converter != null) {
				return $converter.Read($b);
			} else {
				throw new Error("Converter not found : " + $id);
			}
		}
		public static function WriteObject($b:ByteArray, $obj:Object):void {
			if (!_init) Init();
			
			if ($obj == null) {
				$b.writeByte(0);
			} else {
				$b.writeByte(1);
				var $cls:Class = ClassUtils.GetClass($obj);
				var $converter:AutoTypeConverter = _typeLookUp[$cls] as AutoTypeConverter;
				if ($converter != null) {
					$b.writeByte($converter.ID);
					$converter.Write($b, $obj);
				} else {
					throw new Error("Converter not found : " + $cls);
				}
			}
		}
		
		public static function ReadObjectArray($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadObject($b);
			}
			return $ary;
		}
		public static function WriteObjectArray($b:ByteArray, $ary:Array):void {
			if ($ary != null) {
				$b.writeShort($ary.length);
				for (var i:int = 0; i < $ary.length; i++) {
					WriteObject($b, $ary[i] as Object);
				}
			} else {
				$b.writeShort(0);
			}
		}
		
	}

}