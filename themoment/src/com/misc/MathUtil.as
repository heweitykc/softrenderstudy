package com.misc 
{
	import flash.geom.*;
	/**
	 * ...
	 * @author callee
	 */
	public class MathUtil 
	{
		public static function euler2Matrix(vec:Array):Matrix3D
		{
			var quat:Array = QuatFromEulers(vec);
			return quatToMatrix(quat);
		}
		
		public static function QuatFromEulers(vec:Array):Array
		{
			var dSY:Number = Math.sin(vec[2] * 0.5);
			var dSP:Number = Math.sin(vec[1] * 0.5);
			var dSR:Number = Math.sin(vec[0] * 0.5);
			var dCY:Number = Math.cos(vec[2] * 0.5);
			var dCP:Number = Math.cos(vec[1] * 0.5);
			var dCR:Number = Math.cos(vec[0] * 0.5);

			var quat:Array = [];
			quat[0] = dSR * dCP * dCY - dCR * dSP * dSY;
			quat[1] = dCR * dSP * dCY + dSR * dCP * dSY;
			quat[2] = dCR * dCP * dSY - dSR * dSP * dCY;
			quat[3] = dCR * dCP * dCY + dSR * dSP * dSY;
			
			return quat;
		}
		
		public static function quatToMatrix(quat:Array):Matrix3D
		{
			var x:Number=quat[0], y:Number=quat[1], z:Number=quat[2], w:Number=quat[3];
			
			var rawData : Vector.<Number> = new Vector.<Number>(16);
			var xy2 : Number = 2.0 * x * y, xz2 : Number = 2.0 * x * z, xw2 : Number = 2.0 * x * w;
			var yz2 : Number = 2.0 * y * z, yw2 : Number = 2.0 * y * w, zw2 : Number = 2.0 * z * w;
			var xx : Number = x * x, yy : Number = y * y, zz : Number = z * z, ww : Number = w * w;

			rawData[0] = xx - yy - zz + ww;
			rawData[4] = xy2 - zw2;
			rawData[8] = xz2 + yw2;
			rawData[12] = 0;
			rawData[1] = xy2 + zw2;
			rawData[5] = -xx + yy - zz + ww;
			rawData[9] = yz2 - xw2;
			rawData[13] = 0;
			rawData[2] = xz2 - yw2;
			rawData[6] = yz2 + xw2;
			rawData[10] = -xx - yy + zz + ww;
			rawData[14] = 0;
			rawData[3] = 0.0;
			rawData[7] = 0.0;
			rawData[11] = 0;
			rawData[15] = 1;
			
			return new Matrix3D(rawData);
		}
		
		public static function rotate(x:Number,y:Number,z:Number,rx:Number,ry:Number,rz:Number):Matrix3D
		{
			var m:Matrix3D = new Matrix3D();			
			m.appendTranslation(x, y, z);
			m.appendRotation(rx * 180 / Math.PI, Vector3D.X_AXIS);
			m.appendRotation(ry * 180 / Math.PI, Vector3D.Y_AXIS);
			m.appendRotation(rz * 180 / Math.PI, Vector3D.Z_AXIS);
			return m;
		}
	}

}