package com.zam.lol
{
    import flash.geom.*;
    import flash.utils.*;

    public class Util extends Object
    {

        public function Util()
        {
            return;
        }// end function

        public static function readVector3D(param1:ByteArray) : Vector3D
        {
            var _loc_2:* = param1.readFloat();
            var _loc_3:* = param1.readFloat();
            var _loc_4:* = param1.readFloat();
            return new Vector3D(_loc_2, _loc_3, _loc_4);
        }// end function

    }
}
