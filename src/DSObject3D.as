package com.crossxiu.core
{
	import com.crossxiu.BFEngine;
	import com.crossxiu.core.camera.BaseCamera;
	import com.crossxiu.core.math.Matrix3D;
	import com.crossxiu.core.math.Number3D;
	import com.crossxiu.core.math.Quaternion;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.clearInterval;

	/**
	 *  DSObject3D - extend DSObject3DContainer, has contain
	 *  functional, it maintenance 3d control, such as rotation,
	 *  scale, translate, and so on
	 * 
	 * @author harry
	 * 
	 */
	public class DSObject3D extends DSObject3DContainer
	{
		public var world:Matrix3D = null;
		public var view:Matrix3D = null;
		public var screen:Number3D = null;
		public var transform:Matrix3D = null;
		
		private var _rot:Quaternion = new Quaternion();
		protected var _rotationX:Number=.0;
		protected var _rotationY:Number=.0;
		protected var _rotationZ:Number=.0;
		private static var toDEGREES 	:Number = 180/Math.PI;
		private static var toRADIANS 	:Number = Math.PI/180;
		private static var _tempMatrix	:Matrix3D = Matrix3D.IDENTITY; 
		private var _rotation			:Number3D  = Number3D.ZERO; 
		
		protected var _rotationDirty:Boolean = false;
		protected var _transformDirty:Boolean = false;
		protected var _worldLocalDirty:Boolean = false;
		
		protected var _scaleX:Number=1.0;
		protected var _scaleY:Number=1.0;
		protected var _scaleZ:Number=1.0;
		protected var _scale:Number=1.0;
		private var _tempScale:Number3D;
		
		protected var _position:Number3D = null;
		protected var _zIndex:Number = .0;
		
		protected var _name:String;
		protected var _parent:DSObject3DContainer = null;
		protected var _scene:DSObject3DContainer = null;
		public var visible:Boolean = true;
		public var culled:Boolean = false;
		
		
		public function DSObject3D():void
		{
			world = Matrix3D.IDENTITY;
			view = Matrix3D.IDENTITY;
			screen = new Number3D();
			transform = Matrix3D.IDENTITY;
			
			_tempScale = Number3D.ZERO;
			
			_position = Number3D.ZERO;
		}
		
		// ------------------------------------------------------------------------------ common setter/getter
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get parent():DSObject3DContainer
		{
			return _parent;
		}
		
		public function set parent(p:DSObject3DContainer):void
		{
			_parent = p;
		}
		
		public function set scene(s:DSObject3DContainer):void
		{
			_scene = s;
		}
		
		public function get scene():DSObject3DContainer
		{
			return _scene;
		}
		
		// ------------------------------------------------------------------------------- rotation/translate/scale transform
		public function set rotationX(r:Number):void
		{
			this._rotationX = formatRotationValue(r);
			this._transformDirty = true;
		}
		
		public function get rotationX():Number
		{
			if(this._rotationDirty)
				updateRotation();
				
			return formatRotationValue2(_rotationX);
		}
		
		public function set rotationY(r:Number):void
		{
			this._rotationY = formatRotationValue(r);
			this._transformDirty = true;
		}
		
		public function get rotationY():Number
		{
			if(this._rotationDirty)
				updateRotation();
			
			return formatRotationValue2(_rotationY);
		}
		
		public function set rotationZ(r:Number):void
		{
			this._rotationZ = formatRotationValue(r);
			this._transformDirty = true;
		}
		
		public function get rotationZ():Number
		{
			if(this._rotationDirty)
				updateRotation();
			
			return formatRotationValue2(_rotationZ);
		}
		
		public function get scaleX():Number
		{
			return formatPercentValue(_scaleX);
		}
		
		public function get scaleY():Number
		{
			return formatPercentValue(_scaleY);
		}
		
		public function get scaleZ():Number
		{
			return formatPercentValue(_scaleZ);
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scaleX(s:Number):void
		{
			if(this._rotationDirty)
				updateRotation();
			
			this._scaleX = formatPercentValue2(s);
			
			this._transformDirty = true;
		}
		
		public function set scaleY(s:Number):void
		{
			if(this._rotationDirty)
				updateRotation();
			
			this._scaleY = formatPercentValue2(s);
			
			this._transformDirty = true;
		}
		
		public function set scaleZ(s:Number):void
		{
			if(this._rotationDirty)
				updateRotation();
			
			this._scaleZ = formatPercentValue2(s);
			
			this._transformDirty = true;
		}
		
		public function set scale(s:Number):void
		{
			if(this._rotationDirty)
				updateRotation();
			
			this._scaleX = this._scaleY = this._scaleZ = formatPercentValue2(s);
			this._scale = this._scaleX;
			this._transformDirty = true;
		}
		
		public function get position():Number3D
		{
			return _position;
		}
		
		public function set position(p:Number3D):void
		{
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
		}
		
		public function get x():Number
		{
			return transform.n14;
		}
		
		public function set x(v:Number):void
		{
			if(v != transform.n14)
			{
				transform.n14 = v;
				_worldLocalDirty = true;
			}
		}
		
		public function get y():Number
		{
			return transform.n24;
		}
		
		public function set y(v:Number):void
		{
			if(v != transform.n24)
			{
				transform.n24 = v;
				_worldLocalDirty = true;
			}
		}
		
		public function get z():Number
		{
			return transform.n34;
		}
		
		public function set z(v:Number):void
		{
			if(v != transform.n34)
			{
				transform.n34 = v;
				_worldLocalDirty = true;
			}
		}
		
		public function get zIndex():Number
		{
			return _zIndex;// sure word transform is not dirty
		}
		
		public function translate(distance:Number, axis:Number3D):void
		{
			var vector:Number3D = axis.clone();
			
			if(this._transformDirty)
				updateTransform();
			
			Matrix3D.rotateAxis(transform, vector);// how?
			
			this.x += distance * vector.x;
			this.y += distance * vector.y;
			this.z += distance * vector.z;
		}
		
		public function updateTransform():void
		{
			if(_transformDirty || BFEngine.renderEngine.isRenderEnvChange)
			{
				var clockwise:int = 1;//BFEngine.useCLOCKWISE ? -1:1;
				
				_rot.setFromEuler(clockwise*_rotationY, clockwise*_rotationZ, clockwise*_rotationX);// which not _rotationX/Y/Z
				
				// copy rotation
				this.transform.copy3x3( _rot.matrix );
				
				// do scale
				_tempMatrix.reset();
				_tempMatrix.n11 = this._scaleX;
				_tempMatrix.n22 = this._scaleY;
				_tempMatrix.n33 = this._scaleZ;
				this.transform.calculateMultiply( this.transform, _tempMatrix );
				
				_transformDirty = false;
				_worldTransformDirty = true;
			}
		}
		
		public function updateRotation():void
		{
			_tempScale.x = formatPercentValue(_scaleX);
			_tempScale.y = formatPercentValue(_scaleY);
			_tempScale.z = formatPercentValue(_scaleZ);
			
			_rotation = Matrix3D.matrix2euler(this.transform, _rotation, _tempScale);
			
			this._rotationX = _rotation.x * toRADIANS;// degrees to radian
			this._rotationY = _rotation.y * toRADIANS;
			this._rotationZ = _rotation.z * toRADIANS;
			
			this._rotationDirty = false;
		}
		
		// for set
		public function formatRotationValue(r:Number):Number
		{
			var rot:Number = BFEngine.useDEGREES ? r*toRADIANS:toDEGREES;
			return rot;
		}
		
		public function formatRotationValue2(r:Number):Number
		{
			var rot:Number = BFEngine.useDEGREES ? r*toDEGREES:r;
			return rot;
		}
		
		// for get
		public function formatPercentValue(v:Number):Number
		{
			var value:Number = BFEngine.usePERCENT ? v*100:v;
			
			return value;
		}
		
		public function formatPercentValue2(v:Number):Number
		{
			var value:Number = BFEngine.usePERCENT ? v/100:v;
			
			return value;
		}
		
		// ------------------------------------------------------------------------------- project
		public function project(parent:DSObject3D, renderSession:Object):void
		{
			updateTransform();
			
			if(_worldTransformDirty || BFEngine.renderEngine.isRenderEnvChange)
			{
				this.world.calculateMultiply( parent.world, this.transform);
				_worldTransformDirty = false;
			}
			
			var camera:BaseCamera = renderSession.camera;
			
			// project view
			if(parent !== renderSession.camera)
			{
				if(camera.useProjectionMatrix)
					this.view.calculateMultiply4x4(parent.view, this.transform);// ?
				else
					this.view.calculateMultiply(parent.view, this.transform);
			}
			else
			{
				if(camera.useProjectionMatrix)
					this.view.calculateMultiply4x4(camera.eye, this.transform);// ?
				else
					this.view.calculateMultiply(camera.eye, this.transform);
			}
			
			// project all child
			for each(var child:DSObject3D in this._dtChildList)
			{
				if(child.visible)
					child.project(this, renderSession);
			}
		}
		
		private var _worldTransformDirty:Boolean = true;
		public function updateWorldTransform(parent:DSObject3D, session:Object):void
		{
			updateTransform();
			
			/*
			 * 如果camera变化，或者parent.world改变都会要求重新计算，
			 * 如果不将导致不一致问题
			 *
			 * @NOTICE 11.20 2011
			 */
			if(true || _worldTransformDirty  || BFEngine.renderEngine.isRenderEnvChange/* || true*/)
			{
				this.world.calculateMultiply( parent.world, this.transform );
				_worldTransformDirty = false;
				
				// calc zIndex
				updateCameraWorldTransform(session);
			}
			
			// project all child
			for each(var child:DSObject3D in this._dtChildList)
			{
				if(child.visible)
					child.updateWorldTransform(this, session);
			}
		}
		
		private function updateCameraWorldTransform(session:Object):void
		{
			var camera:BaseCamera = session.camera;
			var wTransform:Matrix3D = new Matrix3D();
			wTransform.calculateMultiply4x4(camera.eye, world);
			
			_zIndex = wTransform.n34;
		}
		
		public function invalidateTransform():void
		{
			_transformDirty = true;
		}
		
		public function invalidateRotation():void
		{
			_rotationDirty = true;
		}
		
		public function invalidateWorldTransform():void
		{
			_worldTransformDirty = true;
		}
		
		
		
		
	}
}