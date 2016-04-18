package suity.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Simage
	 */
	public class StringUtils
	{
		public static function IsEmptyMeaning($str:String):Boolean {
			return ($str == null || $str == "" || $str == "null" || $str == "undefined");
		}
		
		public static function IsEmptyMeaningEX($strs:Array):Boolean 
		{
			for each (var $str:String in $strs) {
				if (IsEmptyMeaning($str)) return true;
			}
			return false;
		}
		public static function IsNullOrEmpty($str:String):Boolean {
			return ($str == null || $str == "" || $str == "undefined");
		}
		
		public static function NotEmpty($str:String):Boolean 
		{
			return !IsNullOrEmpty($str);
		}
		
		public static function IsNullOrEmptyEx($strs:Array):Boolean {
			for each (var $str:String in $strs) {
				if (IsNullOrEmpty($str)) return true;
			}
			return false;
		}	
		
		public static function GetUnicodeLen($str:String):int {
			if (IsNullOrEmpty($str)) return 0;
			
			var $len:int = 0;
			for (var $i:int = 0; $i < $str.length; $i++) {
				var $code:int = $str.charCodeAt($i);
				if ($code < 256) {
					$len++;
				} else {
					$len += 2;
				}
			}
			return $len;
		}
		public static function GetUnicodeHeadString($str:String, len:uint):String {
			if (len <= 0 || IsNullOrEmpty($str)) return "";
			var realLen:uint = len;
			var result:String = $str.substr(0, realLen);
			while (GetUnicodeLen(result) > len) {
				realLen--;
				result = $str.substr(0, realLen);
			}
			return result;
		}
		
		
		public static function FillZero($str:String,$len:int,$fill:String="0"):String {
			var $fillLen:int = $len - $str.length;
			if ($fillLen > 0) {
				for (var i:int = 0; i < $fillLen; i++) {
					$str = $fill + $str;
				}
			}
			return $str;
		}
		
		public static function SplitFirst($str:String, $split:String = " "):Array {
			var $index:int = $str.indexOf($split);
			var $ary:Array = new Array();
			if ($index >= 0) {
				$ary.push($str.substr(0, $index));
				$ary.push($str.substr($index + 1, $str.length - $index + 1));
			} else {
				$ary.push($str);
				$ary.push(null);
			}
			return $ary;
		}
		
		/**
		 * Replaces instances of less then, greater then, ampersand, single and double quotes.
		 * @param str String to escape.
		 * @return A string that can be used in an htmlText property.
		 */		
		public static function escapeHTMLText(str:String):String
		{
			var chars:Array = 
			[
				{char:"&", repl:"|amp|"},
				{char:"<", repl:"&lt;"},
				{char:">", repl:"&gt;"},
				{char:"\'", repl:"&apos;"},
				{char:"\"", repl:"&quot;"},
				{char:"|amp|", repl:"&amp;"}
			];
			
			for(var i:int=0; i < chars.length; i++)
			{
				while(str.indexOf(chars[i].char) != -1)
				{
					str = str.replace(chars[i].char, chars[i].repl);
				}
			}
			
			return str;
		}
		public static function descapeHTMLText(str:String):String
		{
			var chars:Array = 
			[
				{char:"|amp|", repl:"&"},
				{char:"&lt;", repl:"<"},
				{char:"&gt;", repl:">"},
				{char:"&apos;", repl:"\'"},
				{char:"&quot;", repl:"\""},
				{char:"&amp;", repl:"|amp|"}
			];
			
			for(var i:int=0; i < chars.length; i++)
			{
				while(str.indexOf(chars[i].char) != -1)
				{
					str = str.replace(chars[i].char, chars[i].repl);
				}
			}
			
			return str;
		}

		public static function replace(source:String, replace:String,replaceWith:String):String
		{
			while (source.indexOf(replace) > -1) {
				source = source.replace(replace, replaceWith);
			}
			return source;
		}
		public static function replaceHead(source:String, replace:String,replaceWith:String):String
		{
			while (source.indexOf(replace) == 0) {
				source = source.replace(replace, replaceWith);
			}
			return source;
		}
		public static function clearnorr(source:String):String
		{
			while (source.charAt(0) == '\n'||source.charAt(0) == '\r') {
				source = source.substring(1);
			}
			while (source.charAt(source.length-1) == '\n'||source.charAt(source.length-1) == '\r') {
				source = source.substring(0,source.length-1);
			}
			return source;
		}
		public static function onlyReplace(source:String, replace:String, replaceWith:String):String {
			
			return source.split(replace).join(replaceWith);
		}
		
		public static function replaceCssStr(source:String, replaceStr:String, replaceWith:String):String
		{
			var result:String = source;
			var index:int = source.indexOf(replaceStr);
			if (index > -1) {
				var end:int = findEndIndex(source, index, ";");
				var tempReplace:String = source.substr(index, end - index+1);
				var midStr:String = (putInStr(replaceWith, findNumStr(tempReplace)));
				var beginStr:String = source.substr(0, index);
				var endStr:String = source.substr(end+1, source.length);
				result = beginStr + midStr + endStr;
			}
			if (result.indexOf(replaceStr) > -1) {
				result = replaceCssStr(result, replaceStr, replaceWith);
			}
			return result;
		}
		private static function findEndIndex(source:String, index:int, endStr:String):int 
		{
			var boo:Boolean;
			var count:int = 1;
			while (!boo) {
				if (endStr == source.charAt(index + count)) {
					boo = true;
					break;
				}
				count++;
			}
			return (index + count);
		}
		public static function putInStr(source:String, putIn:String):String
		{
			var begin:int = source.indexOf("[");
			var end:int = source.indexOf("]");
			var beginStr:String = source.substr(0, begin);
			var endStr:String = source.substr(end+1, source.length - end);
			return beginStr + putIn + endStr;
		}
		
		public static function findNumStr(str:String):String {
			var numStr:String = "";
			for (var i:int = 0; i < str.length; i++) 
			{
				var tempStr:String = str.charAt(i);
				if (isWhitespace(tempStr)) {
					continue;
				}else {
					if (!isNaN(Number(tempStr))) {
						numStr += tempStr;
					}
				}
			}
			return numStr;
		}
		
		/**
		 * 检测是否为空白
		 */
		public static function isWhitespace(char : String) : Boolean {
			switch (char) {
				case "":
				case " " :
				case "\t" :
				case "\r" :
				case "\n" :
				case "\f" :
					return true;
				default :
					return false;
			}
		}
		
		public static function replaceAt(source:String, index:int, replaceWith:String):String {
			var beginStr:String = source.substr(0, index);
			var endStr:String = source.substr(index+1, source.length);
			return beginStr+replaceWith+endStr;
		}
		
		public static function stringTOInArray(str:String, sep:String=" "):Array
		{
			if (IsEmptyMeaning(str))
				return null;
			var result:Array=str.split(sep);
			return result;
		}
		
		public static function Trim($str:String, $trim:String = " "):String {
			$str = TrimLast(TrimFirst($str, "　"), "　");
			return TrimLast(TrimFirst($str, $trim), $trim);
		}
		public static function TrimFirst($str:String, $trim:String = " "):String {
			for (var i:int = 0; i < $str.length; i++) {
				var $char:String = $str.charAt(i);
				if ($trim != $char) {
					if (i > 0) {
						return $str.substr(i, $str.length - i);
					} else {
						return $str;
					}
				}
			}
			return "";
		}
		public static function TrimLast($str:String, $trim:String = " "):String {
			for (var i:int = 0; i < $str.length; i++) {
				var $char:String = $str.charAt($str.length - i - 1);
				if ($trim != $char) {
					if (i > 0) {
						return $str.substr(0, $str.length - i);
					} else {
						return $str;
					}
				}
			}
			return "";
		}
		
		public static function Split($str:String, $delim:String = " "):Array {
			if (StringUtils.IsNullOrEmpty($str)) return [];
			
			var $read:Boolean = false;
			var $strStart:int = 0;
			var $ary:Array = new Array();
			
			for (var i:int = 0; i < $str.length; i++) {
				var $char:String = $str.charAt(i);
				
				if ($read) {
					if ($char == $delim) {
						$read = false;
						$ary.push($str.substring($strStart, i));
					}
				} else {
					if ($char != $delim) {
						$read = true;
						$strStart = i;
					}
				}
			}
			if ($read) {
				$ary.push($str.substring($strStart, i));
			}
			return $ary;
		}
		
		public static function SplitAndTrim($str:String, $splitDelim:String = ";", $trimDelim:String = " "):Array {
			var $ary:Array = Split($str, $splitDelim);
			for (var i:int = 0; i < $ary.length; i++) {
				$ary[i] = Trim($ary[i] as String, $trimDelim);
			}
			return $ary;
		}
		
		public static function SplitAndTrimEx($str:String, $splitDelim:String = ";", $trimDelim:String = " ", $treatAsNull:String = "-"):Array {
			var $ary:Array = Split($str, $splitDelim);
			for (var i:int = 0; i < $ary.length; i++) {
				$str = Trim($ary[i] as String, $trimDelim);
				if ($str == $treatAsNull) $str = null;
				$ary[i] = $str;
			}
			return $ary;
		}
		
		
		public static function Format($str:String, ...$args:Array):String {
			for(var i:int = 0; i<$args.length; i++){
				$str = $str.replace(new RegExp("\\{" + i + "\\}", "gm"), $args[i]);
			}
			return $str;
		}
		public static function FormatArray($str:String, $args:Array):String {
			for(var i:int = 0; i<$args.length; i++){
				$str = $str.replace(new RegExp("\\{" + i + "\\}", "gm"), $args[i]);
			}
			return $str;
		}
		
		/**
		 * 检测屏蔽字
		 * @param	source
		 * @param	wordLib
		 * @return
		 */
		public static function checkScreening(source:String, wordLib:Array):String {
			var len:int = wordLib.length
			for (var i:int = 0; i < len; i++) 
			{
				var searchStr:String = wordLib[i];
				if (NotEmpty(searchStr) && source.toLowerCase().indexOf(searchStr.toLowerCase()) > -1) 
					source = source.toLowerCase().replace(searchStr.toLowerCase(), replaceWord(searchStr.length));
			}
			return source;
		}
		
		private static function replaceWord(len:int):String
		{
			var returnStr:String = "";
			for (var i:int = 0; i < len; i++) 
			{
				returnStr += "*";
			}
			return returnStr;
		}
		
		public static function formatTime(date:Date):String
		{
			var hoursNum:String = String(date.hours);
			hoursNum = (int(hoursNum) < 10)?("0" + hoursNum):(hoursNum);
			var minutesNum:String = String(date.minutes);
			minutesNum = (int(minutesNum) < 10)?("0" + minutesNum):(minutesNum);
			var secondNum:String = String(date.seconds);
			secondNum = (int(secondNum) < 10)?("0" + secondNum):(secondNum);
			return hoursNum + ":" + minutesNum + ":" + secondNum;
		}
		
		public static function SecondToString(second:int):String 
		{
			var result:String = "";
			if (second >= 3600) {
				if (second / 3600 < 10) result += "0";
				result += int(second / 3600);
				result += ":";
			}else {
				result += "00:";
			}
			second = second % 3600;
			if (second >= 60) {
				if (second / 60 < 10) result += "0";
				result += int(second / 60);
				result += ":";
			}else {
				result += "00:";
			}
			second = second % 60;
			if (second < 10) result += "0";
			result += second;
			return result;
		}
		
		public static function GetTime(timenum:Number):String {
			var h:int = int(timenum / 3600);
			var d:int = h / 24;
			h = h % 24;
			var m:int=int((timenum % 3600) / 60);
			var s:int=timenum % 60;
			var t:String="";
			if (timenum > 0)
			{
				if (s >= 0)
				{
					if (s >= 10)
					{
						t=s.toString();
					}
					else
					{
						t="0" + s
					}
				}
				if (m >= 0)
				{
					if (m >= 10)
					{
						t=m + ":" + t;
					}
					else
					{
						t="0" + m + ":" + t;
					}
				}
				if (h >= 0)
				{
					if (h >= 10)
					{
						t=h + ":" + t;
					}
					else
					{
						t="0" + h + ":" + t;
					}
				}
				if ( d > 0 ) {
					t = d + "天 " + t;
				}
			}
			else
			{
				t="00:00:00"
			}
			return t;
		}
		
		public static function ByteArrayToSimpleString(data:ByteArray):String {
			var content:String = "";
			data.position = 0;
			
			for (var i:int = 0; i < data.length; i++) 
			{
				var a:uint = data.readUnsignedByte();
				content +=  String.fromCharCode(a/16 + 97);
				content +=  String.fromCharCode(a%16 + 97);
			}
			return content;
		}
		
		public static function SimpleStringToByteArray(data:String):ByteArray {
			var array:ByteArray = new ByteArray();
			var value:int = 0;
			for (var i:int = 0; i < data.length; i++) 
			{
				var a:uint = uint(data.charCodeAt(i));
				if (i % 2 == 0) {
					value = (a - 97) * 16;
				}else {
					value += (a - 97);
					array.writeByte(value);
					value = 0;
				}
			}
			array.position = 0;
			return array;
		}
		
		/**
		 * @param	data  t:hello,s:1,b:0
		 * @return
		 */
		public static function StringToObj(data:String):Object
		{
			var arr:Array = data.split(",");
			var obj:Object = { };
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:String = arr[i];
				var itemArr:Array = item.split(":");
				obj[itemArr[0]] = itemArr[1];
			}
			return obj;
		}
		
		public static function StrToTxtClick(data:String,LinkTxt:String,color:String = ""):String
		{
			var color1:String = "";
			var color2:String = "";
			if (color != "") {
				color1 = "<font color = '"+color+"'>"
				color2 = "</font>"
			}
			return color1 + "<a href=\"event:" + LinkTxt + "\">" + data + "</a>" + color2;
		}
		
		public static function NumToStr(num:int, type:String = "W"):String
		{
			var str1:String = int(num / 10000).toString();
			if (str1 == "0") return String(num);
			var str2:String = String((num % 10000)/10000);
			str2 = (str2 == "0")?(""):(str2.substr(1,str2.length));
			return (str1 + str2+type);
		}
		static private var date:Date = new Date();
		static public function formatDay(object:Number):String 
		{
			date.setTime(object);
			return date.getFullYear() + "." + int(date.getMonth() + 1) + "." + date.getDate();
		}
		public static function urlencodeUTF8(str:String):String{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"utf8");
			for(var i:int;i<byte.length;i++){
			 result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}
		public static function urlencodeGB2312(str:String):String{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"gb2312");
			for(var i:int;i<byte.length;i++){
			 result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}

		public static function urlencodeBIG5(str:String):String{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"big5");
			for(var i:int;i<byte.length;i++){
				result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}

		public static function urlencodeGBK(str:String):String{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"gbk");
			for(var i:int;i<byte.length;i++){
				result += escape(String.fromCharCode(byte[i]));
			}
		return result;
	   }
	}
}