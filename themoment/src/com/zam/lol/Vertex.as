package com.zam.lol
{
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Vertex extends Object
    {
        public var position:Vector3D;
        public var normal:Vector3D;
        public var u:Number;
        public var v:Number;
        public var bones:Vector.<int>;
        public var weights:Vector.<Number>;

        public function Vertex()
        {
            this.bones = this.Vector.<int>([-1, -1, -1, -1]);
            this.weights = this.Vector.<Number>([0, 0, 0, 0]);
        }

        public function read(param1:ByteArray) : void
        {
            var i:* = 0;
            this.position = Util.readVector3D(param1);
            this.position.w = 1;
            this.normal = Util.readVector3D(param1);
            this.normal.w = 0;
            this.u = param1.readFloat();
            this.v = param1.readFloat();
            i = 0;
            while (i < 4)
            {
                
                this.bones[i] = param1.readUnsignedByte();
                i++;
            }
            i = 0;
            while (i < 4)
            {
                
                this.weights[i] = param1.readFloat();
                i++;
            }
            
        }

    }
}
