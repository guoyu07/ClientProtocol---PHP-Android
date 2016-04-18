package suity.utils 
{
	/**
	 * ...
	 * @author Simage
	 */
	public class MathUtils
	{

		/**
		 * 线性插值
		 * @param	$inA
		 * @param	$inB
		 * @param	$inValue
		 * @param	$outA
		 * @param	$outB
		 * @return
		 */
		public static function Interpolate($inA:Number, $inB:Number, $inValue:Number, $outA:Number, $outB:Number):Number {
			if ($inA == $inB) return $outA;
			var $rate:Number = ($inValue - $inA) / ($inB - $inA);
			return $outA + ($outB - $outA) * $rate;
		}
		
		/**
		 * 线性插值自动裁剪
		 * @param	$inA
		 * @param	$inB
		 * @param	$inValue
		 * @param	$outMin
		 * @param	$outMax
		 * @return
		 */
		public static function InterpolateTrim($inA:Number, $inB:Number, $inValue:Number, $outMin:Number, $outMax:Number):Number {
			var $outValue:Number = Interpolate($inA, $inB, $inValue, $outMin, $outMax);
			return Trim($outValue, $outMin, $outMax);
		}
		
		public static function Trim($value:Number, $min:Number, $max:Number):Number {
			if ($value > $max) $value = $max;
			if ($value < $min) $value = $min;
			return $value;
		}
		
		public static function TrimInt($value:int, $min:int, $max:int):int {
			if ($value > $max) $value = $max;
			if ($value < $min) $value = $min;
			return $value;
		}
		
		/**
		 * 梯形插值
		 * @param	$startX 
		 * @param	$peakX1
		 * @param	$peakX2
		 * @param	$endX
		 * @param	$startY
		 * @param	$peakY
		 * @param	$inValue
		 * @return
		 */
		public static function Trapezoid($startX:Number, $peakX1:Number, $peakX2:Number, $endX:Number, $startY:Number, $peakY:Number, $inValue:Number):Number {
			if ($inValue <= $startX) return $startY;
			if ($inValue >= $endX) return $startY;
			if ($inValue >= $peakX1 && $inValue <= $peakX2) return $peakY;
			if ($inValue < $peakX1) {
				return Interpolate($startX, $peakX1, $inValue, $startY, $peakY);
			} else {
				return Interpolate($peakX2, $endX, $inValue, $peakY, $startY);
			}
		}
	}

}