package com.zam
{
    import flash.geom.*;

    public class Color extends Object
    {
        public var r:Number;
        public var g:Number;
        public var b:Number;
        public var a:Number;
        public static const DEFAULT:Color = new Color(1, 1, 1, 1);

        public function Color(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1)
        {
            this.r = param1;
            this.g = param2;
            this.b = param3;
            this.a = param4;
            return;
        }// end function

        public function set rgb(param1:Vector3D) : void
        {
            this.r = param1.x;
            this.g = param1.y;
            this.b = param1.z;
            return;
        }// end function

        public function reset(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1) : void
        {
            this.r = param1;
            this.g = param2;
            this.b = param3;
            this.a = param4;
            return;
        }// end function

    }
}
