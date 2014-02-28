package com.geomsolid 
{
	import com.core.*;
	import flash.display3D.Context3D;
	
	/**
	 * ...
	 * @author callee
	 */
	public class Box extends SubMeshBase 
	{
		
		public function Box(context3d:Context3D) 
		{
			super(context3d);
			
			var rawVertex:Vector.<Number>;
			var rawIndices:Vector.<uint>;
			
			rawVertex =  Vector.<Number>([
				0.5,   0.5, 0.5,  1, 0, 1,
				0.5,  0.5, -0.5,  0, 1, 1,
				-0.5, 0.5, -0.5,  1, 1, 1,
				
				-0.5, 0.5, 0.5,  1, 0, 1,
				0.5,  -0.5, 0.5,  0, 1, 1,
				-0.5, -0.5, 0.5,  1, 1, 1,
				
				-0.5, -0.5, -0.5,  1, 0, 1,
				0.5,  -0.5, -0.5,  0, 1, 1
			]);
			rawIndices = Vector.<uint>([
				0,1,2,	0,2,3,
				0,7,1,	0,4,7,
				1,7,6,	1,6,2,
				2,6,5,	2,3,5,
				0,5,4,	0,3,5,
				5,6,7,	4,5,7
			]);
			
			this.upload(rawVertex, rawIndices);
		}
		
	}

}