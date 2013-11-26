package com.zam
{
    import flash.geom.*;
    import flash.utils.*;

    public class ZamUtil extends Object
    {

        public function ZamUtil()
        {
            return;
        }// end function

        public static function interpolate(param1:Number, param2:Number, param3:Number) : Number
        {
            return param1 + (param2 - param1) * param3;
        }// end function

        public static function randomInt(param1:int, param2:int) : int
        {
            return param1 + Math.floor(Math.random() * (param2 - param1));
        }// end function

        public static function readVector3D(param1:ByteArray, param2:Boolean = false) : Vector3D
        {
            var _loc_3:* = param1.readFloat();
            var _loc_4:* = param1.readFloat();
            var _loc_5:* = param1.readFloat();
            if (param2)
            {
                return new Vector3D(_loc_3, -_loc_5, _loc_4);
            }
            return new Vector3D(_loc_3, _loc_4, _loc_5);
        }// end function

        public static function readVector3Dc(param1:ByteArray, param2:Boolean = false) : Vector3D
        {
            var _loc_3:* = param1.readUnsignedShort() / 65535 * 2 - 1;
            var _loc_4:* = param1.readUnsignedShort() / 65535 * 2 - 1;
            var _loc_5:* = param1.readUnsignedShort() / 65535 * 2 - 1;
            if (param2)
            {
                return new Vector3D(_loc_3, _loc_5, _loc_4);
            }
            return new Vector3D(_loc_3, _loc_4, _loc_5);
        }// end function

    }
}
