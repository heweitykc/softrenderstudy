package com.zam.wildstar
{
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Vertex extends Object
    {
        public var position:Vector3D;
        public var normal:Vector3D;
        public var tangent:Vector3D;
        public var binormal:Vector3D;
        public var u:Number;
        public var v:Number;

        public function Vertex()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.position = ZamUtil.readVector3D(param1);
            this.position.w = 1;
            this.tangent = ZamUtil.readVector3D(param1);
            this.tangent.w = param1.readFloat();
            this.normal = ZamUtil.readVector3D(param1);
            this.normal.w = param1.readFloat();
            this.binormal = ZamUtil.readVector3D(param1);
            this.binormal.w = param1.readFloat();
            this.u = param1.readFloat();
            this.v = param1.readFloat();
            return;
        }// end function

    }
}
