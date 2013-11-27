package com.zam.tor
{
    import flash.geom.*;

    public class TorVertex extends Object
    {
        public var position:Vector3D;
        public var normal:Vector3D;
        public var tangent:Vector3D;
        public var u:Number;
        public var v:Number;

        public function TorVertex()
        {
            this.position = new Vector3D();
            this.normal = new Vector3D();
            this.tangent = new Vector3D();
            return;
        }// end function

    }
}
