package com.zam
{
    import com.adobe.utils.*;
    import flash.geom.*;

    public class Camera extends Object
    {
        public const _2pi:Number = 6.28319;
        public const _piOver2:Number = 1.5708;
        private var _center:Vector3D;
        private var _distance:Number;
        private var _staticUp:Vector3D;
        private var _staticRight:Vector3D;
        public var _xAngle:Number = 0;
        public var _yAngle:Number = 0;
        private var _zNear:Number = 0.1;
        private var _zFar:Number = 500;
        private var _matrix:Matrix3D;
        private var _modelMatrix:Matrix3D;
        private var _dirtyModelMatrix:Boolean = true;
        private var _viewMatrix:Matrix3D;
        private var _dirtyViewMatrix:Boolean = true;
        private var _projMatrix:PerspectiveMatrix3D;
        private var _position:Vector3D;
        private var _dirtyPosition:Boolean = true;
        private var _direction:Vector3D;
        private var _right:Vector3D;
        private var _dirtyRight:Boolean = true;
        private var _up:Vector3D;
        private var _dirtyUp:Boolean = true;
        private var _viewer:Viewer;
        private var tmpVec:Vector3D;
        private var tmpMat:Matrix3D;
        private var _cameraPos:Vector.<Number>;

        public function Camera(param1:Viewer)
        {
            this._viewer = param1;
            this._center = new Vector3D(0, 0, 0, 1);
            this._staticUp = new Vector3D(0, 1, 0, 0);
            this._staticRight = new Vector3D(1, 0, 0, 0);
            this._distance = 5;
            this._position = new Vector3D(0, 0, 5, 1);
            this._direction = new Vector3D(0, 0, -1, 0);
            this._right = new Vector3D();
            this._up = new Vector3D();
            this._matrix = new Matrix3D();
            this._modelMatrix = new Matrix3D();
            this._viewMatrix = new Matrix3D();
            this._projMatrix = new PerspectiveMatrix3D();
            this._cameraPos = Vector.<Number>([0, 0, 5, 1]);
            this.tmpVec = new Vector3D();
            this.tmpMat = new Matrix3D();
            this.setClipDistance(1000);
            return;
        }// end function

        public function get zNear() : Number
        {
            return this._zNear;
        }// end function

        public function get zFar() : Number
        {
            return this._zFar;
        }// end function

        public function get positionVec() : Vector.<Number>
        {
            this.tmpVec.copyFrom(this.position);
            this._cameraPos[0] = this.tmpVec.x;
            this._cameraPos[1] = this.tmpVec.y;
            this._cameraPos[2] = this.tmpVec.z;
            this._cameraPos[3] = this.tmpVec.w;
            return this._cameraPos;
        }// end function

        public function get position() : Vector3D
        {
            if (this._dirtyPosition)
            {
                VectorUtil.scaleBy(this.direction, -this._distance, this.tmpVec);
                this._position.copyFrom(this._center);
                this._position.incrementBy(this.tmpVec);
                this._dirtyPosition = false;
            }
            return this._position;
        }// end function

        public function get direction() : Vector3D
        {
            return this._direction;
        }// end function

        public function get right() : Vector3D
        {
            if (this._dirtyRight)
            {
                VectorUtil.crossProduct(this._staticUp, this.direction, this._right);
                this._right.normalize();
                this._dirtyRight = false;
            }
            return this._right;
        }// end function

        public function get up() : Vector3D
        {
            if (this._dirtyUp)
            {
                VectorUtil.crossProduct(this.direction, this.right, this._up);
                this._up.normalize();
                this._dirtyUp = false;
            }
            return this._up;
        }// end function

        public function get distance() : Number
        {
            return this._distance;
        }// end function

        public function get matrix() : Matrix3D
        {
            this._matrix.copyFrom(this.viewMatrix);
            this._matrix.append(this._projMatrix);
            return this._matrix;
        }// end function

        public function get projMatrix() : Matrix3D
        {
            return this._projMatrix;
        }// end function

        public function get viewMatrix() : Matrix3D
        {
            if (this._dirtyViewMatrix)
            {
                MatrixUtil.setBasisTransform(this.right, this.up, this.direction, this._viewMatrix);
                this.tmpVec.copyFrom(this.position);
                this._viewMatrix.prependTranslation(-this.tmpVec.x, -this.tmpVec.y, -this.tmpVec.z);
                this._dirtyViewMatrix = false;
            }
            return this._viewMatrix;
        }// end function

        public function get modelMatrix() : Matrix3D
        {
            if (this._dirtyModelMatrix)
            {
                this._modelMatrix.identity();
                this._modelMatrix.appendRotation(this._xAngle * 57.295, this._staticUp);
                this._modelMatrix.appendRotation(this._yAngle * 57.295, this._staticRight);
            }
            return this._modelMatrix;
        }// end function

        public function translate(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_5:* = NaN;
            var _loc_4:* = this.distance / 5 * 0.01;
            if (param1 != 0)
            {
                _loc_5 = param1 > 0 ? (this.distance * 0.1) : (this.distance * 0.15);
                this._distance = this._distance + _loc_5 * (-param1);
                this._dirtyUp = true;
                this._dirtyRight = true;
                this._dirtyModelMatrix = true;
                this._dirtyPosition = true;
                this._dirtyViewMatrix = true;
            }
            if (param2 != 0)
            {
                VectorUtil.scaleBy(this._up, param2 * _loc_4, this.tmpVec);
                this._position.incrementBy(this.tmpVec);
                this._center.incrementBy(this.tmpVec);
                this._dirtyUp = true;
                this._dirtyRight = true;
                this._dirtyModelMatrix = true;
                this._dirtyPosition = true;
                this._dirtyViewMatrix = true;
            }
            if (param3 != 0)
            {
                VectorUtil.scaleBy(this.right, (-param3) * _loc_4, this.tmpVec);
                this._position.incrementBy(this.tmpVec);
                this._center.incrementBy(this.tmpVec);
                this._dirtyUp = true;
                this._dirtyRight = true;
                this._dirtyModelMatrix = true;
                this._dirtyPosition = true;
                this._dirtyViewMatrix = true;
            }
            return;
        }// end function

        public function rotate(param1:Number, param2:Number) : void
        {
            if (param1 != 0)
            {
                this._xAngle = this._xAngle + (-param1);
                if (this._xAngle > this._2pi)
                {
                    this._xAngle = this._xAngle - this._2pi;
                }
                else if (this._xAngle < 0)
                {
                    this._xAngle = this._xAngle + this._2pi;
                }
                var _loc_3:* = true;
                this._dirtyUp = true;
                this._dirtyRight = _loc_3;
                this._dirtyModelMatrix = _loc_3;
                this._dirtyPosition = _loc_3;
                this._dirtyViewMatrix = _loc_3;
            }
            if (param2 != 0)
            {
                this._yAngle = this._yAngle + param2;
                if (this._yAngle > this._piOver2 - 0.01)
                {
                    this._yAngle = this._piOver2 - 0.01;
                }
                else if (this._yAngle < -this._piOver2 + 0.01)
                {
                    this._yAngle = -this._piOver2 + 0.01;
                }
                this._dirtyUp = true;
                this._dirtyRight = true;
                this._dirtyModelMatrix = true;
                this._dirtyPosition = true;
                this._dirtyViewMatrix = true;
            }
            return;
        }// end function

        public function setDistance(param1:Number) : void
        {
            this._distance = param1;
            var _loc_2:* = true;
            this._dirtyUp = true;
            this._dirtyRight = _loc_2;
            this._dirtyModelMatrix = _loc_2;
            this._dirtyPosition = _loc_2;
            this._dirtyViewMatrix = _loc_2;
            return;
        }// end function

        public function setClipDistance(param1:Number) : void
        {
            var _loc_2:* = this._viewer.stage.stageWidth / this._viewer.stage.stageHeight;
			this._zNear = 1;
			this._zFar = 5000;
            var _loc_3:* = 45 * (Math.PI / 180);
            this._projMatrix.perspectiveFieldOfViewLH(_loc_3, _loc_2, this._zNear, this._zFar);
            return;
        }// end function

    }
}
