package com.zam.lol
{
    import __AS3__.vec.*;
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

        public function Bone(param1:LolMesh, param2:int)
        {
            this._mesh = param1;
            this.index = param2;
            return;
        }// end function

        public function read(param1:ByteArray, param2:uint) : void
        {
            var _loc_3:* = 0;
            this.name = param1.readUTF();
            this.name = this.name.toLowerCase();
            this.parent = param1.readInt();
            this.scale = param1.readFloat();
            var _loc_4:* = new Vector.<Number>(16);
            _loc_3 = 0;
            while (_loc_3 < 16)
            {
                
                _loc_4[_loc_3] = param1.readFloat();
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
                    
                    _loc_4[_loc_3] = param1.readFloat();
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
