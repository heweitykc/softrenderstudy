package com.zam.lol
{
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Bone extends Object
    {
        public var name:String;
        public var parent:int;
        public var index:int;
        public var scale:Number;
        public var baseMatrix:Matrix3D;
        public var origMatrix:Matrix3D;
        public var incrMatrix:Matrix3D;
        public var calc:Boolean;
        public var fixed:Boolean;
        protected var _mesh:LolMesh;

        public function Bone(mesh:LolMesh, index:int)
        {
            this._mesh = mesh;
            this.index = index;
            return;
        }// end function

        public function read(bts:ByteArray, param2:uint) : void
        {
            var _loc_3:* = 0;
            this.name = bts.readUTF();
            this.name = this.name.toLowerCase();
            this.parent = bts.readInt();
            this.scale = bts.readFloat();
            var _loc_4:* = new Vector.<Number>(16);
            _loc_3 = 0;
            while (_loc_3 < 16)
            {
                
                _loc_4[_loc_3] = bts.readFloat();
                _loc_3++;
            }
            this.origMatrix = new Matrix3D(_loc_4);
            this.origMatrix.transpose();
            this.baseMatrix = new Matrix3D(_loc_4);
            MatrixUtil.invert(this.baseMatrix);
            this.baseMatrix.transpose();
            if (param2 >= 2)
            {
                _loc_3 = 0;
                while (_loc_3 < 16)
                {
                    
                    _loc_4[_loc_3] = bts.readFloat();
                    _loc_3++;
                }
                this.incrMatrix = new Matrix3D(_loc_4);
                this.incrMatrix.transpose();
            }
            this.fixed = false;
            return;
        }// end function

    }
}
