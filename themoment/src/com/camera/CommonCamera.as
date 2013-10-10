package com.camera
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	public class CommonCamera
	{
		protected var projectionTransform:PerspectiveMatrix3D;
		protected var cameraWorldTransform:Matrix3D;
		protected var viewTransform:Matrix3D;
		protected var cameraLinearVelocity:Vector3D;
		protected var cameraRotationVelocity:Number;
		protected var cameraRotationAcceleration:Number;
		protected var cameraLinearAcceleration:Number;
		
		protected const MAX_FORWARD_VELOCITY:Number = 0.05;
		protected const MAX_ROTATION_VELOCITY:Number = 0.5;
		protected const LINEAR_ACCELERATION:Number = 0.0005;
		protected const ROTATION_ACCELERATION:Number = 0.01;
		protected const DAMPING:Number = 1.09;
		
		private var _stage:Stage;
		
		public function CommonCamera(stage:Stage)
		{
			_stage = stage;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler );   
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEventHandler );
		}
		
		protected function keyDownEventHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{ 
				case 37:
					cameraRotationAcceleration = -ROTATION_ACCELERATION;
					break
				case 38:
					cameraLinearAcceleration = LINEAR_ACCELERATION;
					break
				case 39:
					cameraRotationAcceleration = ROTATION_ACCELERATION;
					break;
				case 40:
					cameraLinearAcceleration = -LINEAR_ACCELERATION;
					break;
			}
		}
		
		protected function keyUpEventHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{ 
				case 37:
				case 39:
					cameraRotationAcceleration = 0;
					break
				case 38:
				case 40:
					cameraLinearAcceleration = 0;
					break
			}			
		}
		
		public function init():void
		{
			cameraWorldTransform = new Matrix3D();
			cameraWorldTransform.appendTranslation(0, 0, -2);
			viewTransform = new Matrix3D();
			viewTransform = cameraWorldTransform.clone();
			viewTransform.invert();			
			
			cameraLinearVelocity = new Vector3D();
			cameraRotationVelocity = 0;
			
			cameraLinearAcceleration = 0;
			cameraRotationAcceleration = 0;
			
			projectionTransform = new PerspectiveMatrix3D();
			var aspect:Number = 4/3;
			var zNear:Number = 0.1;
			var zFar:Number = 1000;
			var fov:Number = 45*Math.PI/180;
			projectionTransform.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);
		}
		
		protected function calculateUpdatedVelocity(curVelocity:Number, curAcceleration:Number, maxVelocity:Number):Number
		{
			var newVelocity:Number;
			
			if (curAcceleration != 0)
			{
				newVelocity = curVelocity + curAcceleration;
				if (newVelocity > maxVelocity)
				{
					newVelocity = maxVelocity;
				}
				else if (newVelocity < -maxVelocity)
				{
					newVelocity = - maxVelocity;
				}
			}
			else
			{
				newVelocity = curVelocity / DAMPING;
			}
			return newVelocity;
		}
		
		protected function updateViewMatrix():void
		{
			cameraLinearVelocity.z = calculateUpdatedVelocity(cameraLinearVelocity.z, cameraLinearAcceleration, MAX_FORWARD_VELOCITY);
			cameraRotationVelocity = calculateUpdatedVelocity(cameraRotationVelocity, cameraRotationAcceleration, MAX_ROTATION_VELOCITY); 
			
			cameraWorldTransform.appendRotation(cameraRotationVelocity, Vector3D.Y_AXIS, cameraWorldTransform.position);			
			cameraWorldTransform.position = cameraWorldTransform.transformVector(cameraLinearVelocity);			
			
			viewTransform.copyFrom(cameraWorldTransform);
			viewTransform.invert();
		}
		
		public var m:Matrix3D = new Matrix3D();
		
		public function loop():void
		{
			updateViewMatrix();
			
			m.identity();
			//m.appendRotation(getTimer()/30, Vector3D.Y_AXIS);
			//m.appendRotation(getTimer()/10, Vector3D.X_AXIS);
			m.appendTranslation(0, 0, 2);
			m.append(viewTransform);
			m.append(projectionTransform);
		}
	}
}