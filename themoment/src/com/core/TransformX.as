package com.core
{
    import flash.geom.*;

   public  class TransformX extends Object
    {
        public var translation:Vector3D;
        public var rotation:Quaternion;
        public var scale:Vector3D;

        function TransformX()
        {
            this.translation = new Vector3D(0, 0, 0);
            this.rotation = new Quaternion();
            this.scale = new Vector3D(1, 1, 1);
            return;
        }// end function

        public function copyFrom(param1:TransformX) : void
        {
            this.translation.copyFrom(param1.translation);
            this.rotation.copyFrom(param1.rotation);
            this.scale.copyFrom(param1.scale);
            return;
        }// end function

        public function toMatrix3D(param1:Matrix3D) : void
        {
            this.rotation.toMatrix(param1, this.translation, this.scale);
            return;
        }// end function

        public function reset() : void
        {
            this.translation.setTo(0, 0, 0);
            this.rotation.setTo(0, 0, 0, 1);
            this.scale.setTo(1, 1, 1);
            return;
        }// end function

    }
}
