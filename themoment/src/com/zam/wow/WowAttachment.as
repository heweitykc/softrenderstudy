package com.zam.wow
{
    import flash.geom.*;
    import flash.utils.*;

    public class WowAttachment extends Object
    {
        public var _id:int;
        public var _bone:int;
        public var _position:Vector3D;
        public var _slot:int;

        public function WowAttachment()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this._id = param1.readInt();
            this._bone = param1.readInt();
            this._position = WowUtil.readVector3D(param1);
            return;
        }// end function

    }
}
