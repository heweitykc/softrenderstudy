package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowAnimation extends Object
    {
        public var id:uint;
        public var subId:uint;
        public var flags:uint;
        public var length:uint;
        public var playbackSpeed:Number;
        public var nextAnim:int;
        public var index:uint;
        public var available:Boolean;
        public var dbcFlags:uint;
        public var name:String;
        public var _translation:Vector.<AnimatedVector3D>;
        public var _scale:Vector.<AnimatedVector3D>;
        public var _rotation:Vector.<AnimatedQuaternion>;

        public function WowAnimation()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            this.id = param1.readUnsignedShort();
            this.subId = param1.readUnsignedShort();
            this.flags = param1.readUnsignedInt();
            this.length = param1.readUnsignedInt();
            this.playbackSpeed = param1.readFloat();
            this.nextAnim = param1.readShort();
            this.index = param1.readUnsignedShort();
            this.available = param1.readBoolean();
            if (this.available)
            {
                this.dbcFlags = param1.readUnsignedInt();
                this.name = param1.readUTF();
                _loc_2 = param1.readInt();
                this._translation = new Vector.<AnimatedVector3D>(_loc_2);
                this._rotation = new Vector.<AnimatedQuaternion>(_loc_2);
                this._scale = new Vector.<AnimatedVector3D>(_loc_2);
                if (_loc_2 > 0)
                {
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2)
                    {
                        
                        this._translation[_loc_3] = new AnimatedVector3D();
                        this._rotation[_loc_3] = new AnimatedQuaternion();
                        this._scale[_loc_3] = new AnimatedVector3D();
                        this._translation[_loc_3].read(param1);
                        this._rotation[_loc_3].read(param1);
                        this._scale[_loc_3].read(param1);
                        _loc_3++;
                    }
                }
            }
            else
            {
                this._translation = new Vector.<AnimatedVector3D>(0);
                this._rotation = new Vector.<AnimatedQuaternion>(0);
                this._scale = new Vector.<AnimatedVector3D>(0);
            }
            return;
        }// end function

    }
}
