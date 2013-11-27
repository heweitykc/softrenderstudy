package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowTextureAnimation extends Object
    {
        public var translation:Vector.<AnimatedVector3D>;
        public var rotation:Vector.<AnimatedQuaternion>;
        public var scale:Vector.<AnimatedVector3D>;

        public function WowTextureAnimation()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.translation = WowUtil.readAnimatedVector3DSet(param1);
            this.rotation = WowUtil.readAnimatedQuaternionSet(param1);
            this.scale = WowUtil.readAnimatedVector3DSet(param1);
            return;
        }// end function

    }
}
