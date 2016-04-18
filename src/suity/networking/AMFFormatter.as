package suity.networking 
{
	/**
	 * ...
	 * @author Simage
	 */
	public class AMFFormatter
	{
		
		public static function ReadBoolean($obj:*):Boolean { return Boolean($obj); }
		public static function WriteBoolean($v:Boolean):* { return $v; }
		
		public static function ReadByte($obj:*):int { return int($obj); }
		public static function WriteByte($v:int):* { return $v;}

		public static function ReadSByte($obj:*):int { return int($obj); }
		public static function WriteSByte($v:int):* { return $v; }

		public static function ReadInt16($obj:*):int { return int($obj); }
		public static function WriteInt16($v:int):* { return $v; }
		
		public static function ReadInt32($obj:*):int { return int($obj); }
		public static function WriteInt32($v:int):* { return $v; }
		
		public static function ReadInt64($obj:*):Number { throw new Error(); }
		public static function WriteInt64($v:Number):* { throw new Error(); }
		
		public static function ReadUInt16($obj:*):int { return int($obj); }
		public static function WriteUInt16($v:int):* { return $v; }
		
		public static function ReadUInt32($obj:*):int { return int($obj); }
		public static function WriteUInt32($v:int):* { return $v; }
		
		public static function ReadUInt64($obj:*):Number { return Number($obj); }
		public static function WriteUInt64($v:Number):* { return $v; }

		public static function ReadSingle($obj:*):Number { return Number($obj); }
		public static function WriteSingle($v:Number):* { return $v; }

		public static function ReadDouble($obj:*):Number { return Number($obj); }
		public static function WriteDouble($v:Number):* { return $v; }

		public static function ReadString($obj:*):String { return String($obj); }
		public static function WriteString($v:String):* { return $v; }
		
	}

}