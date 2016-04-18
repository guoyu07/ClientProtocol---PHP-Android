package suity.networking 
{
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	
	/**
	 * 串行化内置类型
	 * @author Simage
	 */
	public class RPCFormatter 
	{

		public static function ReadBoolean($b:ByteArray):Boolean { return $b.readBoolean(); }
		public static function WriteBoolean($b:ByteArray, $v:Boolean):void { $b.writeBoolean($v); }
		
		public static function ReadByte($b:ByteArray):uint { return $b.readUnsignedByte(); }
		public static function WriteByte($b:ByteArray, $v:uint):void { $b.writeByte(int($v));}  // 正负数无关

		public static function ReadSByte($b:ByteArray):int { return $b.readByte(); }
		public static function WriteSByte($b:ByteArray, $v:int):void { $b.writeByte($v);}

		public static function ReadInt16($b:ByteArray):int { return $b.readShort(); }
		public static function WriteInt16($b:ByteArray, $v:int):void { $b.writeShort($v); }
		
		public static function ReadInt32($b:ByteArray):int { return $b.readInt(); }
		public static function WriteInt32($b:ByteArray, $v:int):void { $b.writeInt($v); }
		
		public static function ReadInt64($b:ByteArray):Number { throw new Error(); }
		public static function WriteInt64($b:ByteArray, $v:Number):void { throw new Error(); }
		
		public static function ReadUInt16($b:ByteArray):int { return $b.readUnsignedShort(); }
		public static function WriteUInt16($b:ByteArray, $v:int):void { $b.writeShort($v); }
		
		public static function ReadUInt32($b:ByteArray):int { return $b.readUnsignedInt(); }
		public static function WriteUInt32($b:ByteArray, $v:int):void { $b.writeInt($v); }
		
		public static function ReadUInt64($b:ByteArray):Number { throw new Error(); }
		public static function WriteUInt64($b:ByteArray, $v:Number):void { throw new Error(); }

		public static function ReadSingle($b:ByteArray):Number { return $b.readFloat(); }
		public static function WriteSingle($b:ByteArray, $v:Number):void { $b.writeFloat($v); }

		public static function ReadDouble($b:ByteArray):Number { return $b.readDouble(); }
		public static function WriteDouble($b:ByteArray, $v:Number):void { $b.writeDouble($v); }

		public static function ReadString($b:ByteArray):String { return $b.readUTF(); }
		public static function WriteString($b:ByteArray, $v:String):void { if ($v == null) $v = "";  $b.writeUTF($v); }

		public static function ReadRawDateTime($b:ByteArray):RawDateTime { return RawDateTime.FromByteArray($b); }
		public static function WriteRawDateTime($b:ByteArray, $v:RawDateTime):void { $v.Write($b); }

		public static function ReadRawDate($b:ByteArray):RawDate { return RawDate.FromByteArray($b); }
		public static function WriteRawDate($b:ByteArray, $v:RawDate):void { $v.Write($b); }

		public static function ReadRawTime($b:ByteArray):RawTime { return RawTime.FromByteArray($b); }
		public static function WriteRawTime($b:ByteArray, $v:RawTime):void { $v.Write($b); }

		public static function ReadRawTimeSpan($b:ByteArray):RawTimeSpan { return RawTimeSpan.FromByteArray($b); }
		public static function WriteRawTimeSpan($b:ByteArray, $v:RawTimeSpan):void { $v.Write($b); }

		//public static function ReadGuid($b:ByteArray):void { return $b.readGuid(); }
		//public static function WriteGuid($b:ByteArray, $v:Guid):void { $b.writeGuid($v); }

		public static function ReadIPEndPoint($b:ByteArray):IPEndPoint { return IPEndPoint.FromByteArray($b); }
		public static function WriteIPEndPoint($b:ByteArray, $v:IPEndPoint):void { $v.Write($b); }

		public static function ReadIPAddress($b:ByteArray):IPAddress { return IPAddress.FromByteArray($b); }
		public static function WriteIPAddress($b:ByteArray, $v:IPAddress):void { $v.Write($b); }
		
		
		
		public static function ReadByteArray($b:ByteArray):ByteArray {
			var $len:int = $b.readUnsignedShort();
			var $v:ByteArray = new ByteArray();
			if ($len > 0) {
				$b.readBytes($v, 0, $len);
			}
			return $v;
		}
		public static function WriteByteArray($b:ByteArray, $v:ByteArray):void {
			$v.position = 0;
			$b.writeShort($v.length)
			$b.writeBytes($v, 0, $v.length);
		}
		//将ByteArray转为Array
		public static function ReadByteArrayToArray($b:ByteArray):Array
		{
			var $len:int = $b.length;
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadByte($b);
			}
			return $ary;
		}
		
		// 专为枚举数组而设
		public static function ReadUInt8Array($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadByte($b);
			}
			return $ary;
		}
		public static function WriteUInt8Array($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteByte($b, uint($ary[i]));
			}
		}
		
		public static function ReadInt16Array($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadInt16($b);
			}
			return $ary;
		}
		public static function WriteInt16Array($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteInt16($b, int($ary[i]));
			}
		}
		
		public static function ReadUInt16Array($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadUInt16($b);
			}
			return $ary;
		}
		public static function WriteUInt16Array($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteUInt16($b, int($ary[i]));
			}
		}
		
		public static function ReadInt32Array($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadInt32($b);
			}
			return $ary;
		}
		public static function WriteInt32Array($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteInt32($b, int($ary[i]));
			}
		}

		public static function ReadUInt32Array($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary[i] = ReadUInt32($b);
			}
			return $ary;
		}
		public static function WriteUInt32Array($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteUInt32($b, int($ary[i]));
			}
		}
		
		public static function ReadStringArray($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary.push(ReadString($b));
			}
			return $ary;
		}
		public static function WriteStringArray($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteString($b, String($ary[i]));
			}
		}

		public static function ReadBooleanArray($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary.push(ReadBoolean($b));
			}
			return $ary;
		}
		public static function WriteBooleanArray($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteBoolean($b, Boolean($ary[i]));
			}
		}
		
		public static function ReadIPEndPointArray($b:ByteArray):Array {
			var $len:int = $b.readUnsignedShort();
			var $ary:Array = new Array();
			for (var i:int = 0; i < $len; i++) {
				$ary.push(ReadIPEndPoint($b));
			}
			return $ary;
		}
		public static function WriteIPEndPointArray($b:ByteArray, $ary:Array):void {
			$b.writeShort($ary.length);
			for (var i:int = 0; i < $ary.length; i++) {
				WriteIPEndPoint($b, IPEndPoint($ary[i]));
			}
		}
		
		
		
		public static function TraceByteArray($b:ByteArray):String {
			var $str:String = "";
			for (var i:int = 0; i < $b.length; i++) {
				$str += String($b[i]) + " ";
			}
			return $str;
		}
	}
	
}