package com.geomsolid
{
	import com.core.Mesh;
	
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	public class Plane extends Mesh
	{
		private var _w:Number;
		private var _h:Number;
		private var _vertical:Vector3D;
		
		public function Plane(context3d:Context3D,w:Number,h:Number, vertical:Vector3D)
		{
			super(context3d);
			_w = w;
			_h = h;
			_vertical = vertical;
			
			init();
		}
		
		private function init():void
		{
			var _rawVertex:Vector.<Number> = Vector.<Number>([
				_w, -0.5, _h, 1,1,1,
				_w, -0.5, -_h, 1,1,1,
				-_w, -0.5, -_h, 1,1,1,
				-_w, -0.5, _h, 1,1,1
			]);
			
			var _rawIndices:Vector.<uint> = Vector.<uint>([
				0,1,2, 0,2,3
			]);
			
			this.upload(_rawVertex, _rawIndices);
		}
	}
}