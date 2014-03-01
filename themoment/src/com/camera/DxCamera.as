package com.camera
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 *  辅助遨游摄像头
	 * */
	public class DxCamera
	{
		public static const LANDOBJECT:uint = 0;
		public static const AIRCRAFT:uint = 1;
		
		private var _right:Vector3D;
		private var _up:Vector3D;
		private var _look:Vector3D;
		private var _pos:Vector3D;
		
		private var _cameraType:uint;
		
		public function DxCamera(type:uint)
		{
			_cameraType = type;
			_pos =   new Vector3D(0,0,-10);
			_right = new Vector3D(1,0,0);
			_up =    new Vector3D(0,1,0);
			_look =  new Vector3D(0,0,1);
		}
		
		public function strafe(units:Number):void
		{
			var vec:Vector3D;
			if(_cameraType == LANDOBJECT){
				vec = new Vector3D(_right.x,0,_right.z);
				vec.scaleBy(units)
				_pos = _pos.add(vec);
			}else{
				var vec2:Vector3D = _right.clone();
				vec2.scaleBy(units);
				_pos = _pos.add(vec2);
			}	
		}
		
		public function fly(units:Number):void
		{
			if(_cameraType == LANDOBJECT){
				_pos.y += units;
			}
			else{
				var vec2:Vector3D = _up.clone();
				vec2.scaleBy(units);
				_pos = _pos.add(vec2);
			}
		}
		
		public function walk(units:Number):void
		{
			var vec:Vector3D; 
			if(_cameraType == LANDOBJECT){
				vec = new Vector3D(_look.x,0,_look.z);
				vec.scaleBy(units);
				_pos = _pos.add(vec);
			}
			else{
				var vec2:Vector3D = _look.clone();
				vec2.scaleBy(units);
				_pos = _pos.add(vec2);
			}
		}
		
		public function pitch(angle:Number):void
		{
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(angle,_right);
			
			_up = m.transformVector(_up);
			_look = m.transformVector(_look);
		}
		
		public function yaw(angle:Number):void
		{
			var m:Matrix3D = new Matrix3D();
			if(_cameraType == LANDOBJECT)
				m.appendRotation(angle,new Vector3D(0,1,0));
			else
				m.appendRotation(angle,_up);
			
			_right = m.transformVector(_right);
			_look = m.transformVector(_look);
		}
		
		public function roll(angle:Number):void
		{
			if(_cameraType == AIRCRAFT)
			{
				var m:Matrix3D = new Matrix3D();
				m.appendRotation(angle,_look);
				
				_right = m.transformVector(_right);
				_up = m.transformVector(_up);
			}
		}
		
		public function get viewMatrix():Matrix3D
		{
			_look.normalize();
			_up = _look.crossProduct(_right);
			_up.normalize();
			
			_right = _up.crossProduct(_look);
			_right.normalize();
			
			var x:Number = -1 * (_right.dotProduct(_pos));
			var y:Number = -1 * (_up.dotProduct(_pos));
			var z:Number = -1 * (_look.dotProduct(_pos));
			
			var vecs:Vector.<Number> = Vector.<Number>([
				_right.x, _up.x, _look.x, 0,
				_right.y, _up.y, _look.y, 0,
				_right.z, _up.z, _look.z, 0,
				 x, 		y, 		z, 	   1
			]);
			
			var m:Matrix3D = new Matrix3D(vecs);
			return m;
		}
		
		public function set position(value:Vector3D):void
		{
			_pos = value;
		}
		
		public function get position():Vector3D
		{
			return _pos;
		}
		
		public function get right():Vector3D
		{
			return _right;
		}
		
		public function get up():Vector3D
		{
			return _up;
		}
		
		public function get look():Vector3D
		{
			return _look;
		}
		
		
	}
}