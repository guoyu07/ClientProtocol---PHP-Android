package suity.utils 
{
	/**
	 * ...
	 * @author simage
	 */
	public function Format($str:String, ...$args:Array):String {
		var $inText:Boolean = true;
		var $strStart:int = 0;
		var $ary:Array = new Array;
		if (!$str || $str == "") return "";
		for (var i:int = 0; i < $str.length; i++) {
			var $char:String = $str.charAt(i);
			
			if ($inText) {
				if ($char == "{") {
					$inText = false;
					$ary.push($str.substring($strStart, i));
					i++;
					$strStart = i;
				} else if ($char == "}") {
					throw new Error("Pattern format error.");
				}
			} else {
				if ($char == "}") {
					$inText = true;
					$ary.push(int($str.substring($strStart, i)));
					i++;
					$strStart = i;
				} else if ($char == "{") {
					throw new Error("Pattern format error.");
				}
			}
		}
		if ($inText) {
			$ary.push($str.substring($strStart, i));
		} else {
			throw new Error("Pattern format error.");
		}
		
		var $result:String = "";
		for (var j:int = 0; j < $ary.length; j++) {
			if ($ary[j] is int) {
				$result += $args[int($ary[j])];
			} else {
				$result += $ary[j];
			}
		}
		return $result;
	}

}