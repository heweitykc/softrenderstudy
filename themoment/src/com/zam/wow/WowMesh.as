package com.zam.wow
{
    import flash.geom.*;
    import flash.utils.*;

    public class WowMesh extends Object
    {
        public var id:uint;
        public var vertexStart:uint;
        public var vertexCount:uint;
        public var indexStart:uint;
        public var indexCount:uint;
        public var centerOfMass:Vector3D;
        public var centerBounds:Vector3D;
        public var radius:Number;

        public function WowMesh()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.id = param1.readUnsignedInt();
            this.vertexStart = param1.readUnsignedShort();
            this.vertexCount = param1.readUnsignedShort();
            this.indexStart = param1.readUnsignedShort();
            this.indexCount = param1.readUnsignedShort();
            this.centerOfMass = WowUtil.readVector3D(param1);
            this.centerBounds = WowUtil.readVector3D(param1);
            this.radius = param1.readFloat();
            return;
        }// end function

    }
}
