package com.zam.wow
{
    import flash.geom.*;
    import flash.utils.*;

    public class WowVertex extends Object
    {
        public var _position:Vector3D;
        public var _transformedPosition:Vector3D;
        public var _normal:Vector3D;
        public var _transformedNormal:Vector3D;
        public var _texCoord:Object;
        public var _bones:Array;
        public var _weights:Array;
        public var currentTime:int;

        public function WowVertex()
        {
            this._texCoord = {u:0, v:0};
            this._bones = [-1, -1, -1, -1];
            this._weights = [0, 0, 0, 0];
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            var _loc_2:* = 0;
            this._position = WowUtil.readVector3D(param1);
            this._position.w = 1;
            this._transformedPosition = this._position.clone();
            this._normal = WowUtil.readVector3D(param1);
            this._normal.normalize();
            this._transformedNormal = this._normal.clone();
            this._texCoord.u = param1.readFloat();
            this._texCoord.v = param1.readFloat();
            _loc_2 = 0;
            while (_loc_2 < 4)
            {
                
                this._weights[_loc_2] = param1.readUnsignedByte();
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < 4)
            {
                
                this._bones[_loc_2] = param1.readUnsignedByte();
                _loc_2++;
            }
            return;
        }// end function

    }
}
