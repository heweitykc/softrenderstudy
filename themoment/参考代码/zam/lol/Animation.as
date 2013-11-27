package com.zam.lol
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class Animation extends Object
    {
        public var name:String;
        public var fps:int;
        public var bones:Vector.<AnimationBone>;
        public var lookup:Dictionary;
        public var duration:int;
        public var meshOverride:Dictionary;
        private var _mesh:LolMesh;

        public function Animation(param1:LolMesh)
        {
            this._mesh = param1;
            this.meshOverride = new Dictionary();
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.name = param1.readUTF().toLowerCase();
            this.fps = param1.readInt();
            var _loc_2:* = param1.readUnsignedInt();
            this.bones = new Vector.<AnimationBone>(_loc_2);
            this.lookup = new Dictionary();
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.bones[_loc_3] = new AnimationBone(this._mesh, this);
                this.bones[_loc_3].read(param1);
                if (this.lookup[this.bones[_loc_3].bone] !== undefined)
                {
                    this.bones[_loc_3].bone = this.bones[_loc_3].bone + "2";
                }
                this.lookup[this.bones[_loc_3].bone] = _loc_3;
                _loc_3 = _loc_3 + 1;
            }
            this.duration = Math.floor(1000 * (this.bones[0].frames.length / this.fps));
            return;
        }// end function

    }
}
