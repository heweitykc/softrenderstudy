package com.terrain
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class TerrainData
	{
		[Embed(source="../../../assets/coastMountain64.raw",mimeType = "application/octet-stream")] 
		private const terrainData : Class;
		
		private var _heightMap:Vector.<uint>;
		private var _rawVertex:Vector.<Number>;
		private var _rawIndex:Vector.<uint>;
		
		private var uCoordIncrementSize:Number = 1.0; 	// 每列顶点数;
		private var vCoordIncrementSize:Number = 1.0; 	// 每行顶点数;
		private var _cellSpacing:Number = 1.0; 			//每行顶点数;
		private var _numVertsPerRow:int = 6; 			//顶点格式
		
		private var _numCellsperCol:int = 64; 			//column
		private var _numCellsPerRow:int = 64; 			//row
		private var _heightScale:Number = 1/20;
		private var _cellScale:Number = 1/10;
		
		public function TerrainData()
		{
			_heightMap = new Vector.<uint>();
			_rawVertex = new Vector.<Number>();
			_rawIndex = new Vector.<uint>();
			
			parseHeightMaps(new terrainData());
			generateVertex();
			generateIndices();
		}
		
		public function get vertices():Vector.<Number>
		{
			return _rawVertex;
		}
		
		public function get verticesSize():uint
		{
			return _numVertsPerRow;
		}
		
		public function get indices():Vector.<uint>
		{
			return _rawIndex;
		}
		
		private function parseHeightMaps(data:ByteArray) : Boolean
		{
			if(null == data || 0 == data.bytesAvailable) return false;
			
			var len : uint = data.bytesAvailable;
			for(var i : int = 0; i < len; i++){
				_heightMap.push(data.readUnsignedByte());
			}
			return true;
		}
		
		private function generateVertex():void
		{
			for(var x:int = 0; x<_numCellsperCol; x++)
			{
				for(var z:int = 0; z<_numCellsPerRow; z++)
				{
					var scale:Number = _heightMap[x * _numCellsPerRow + z] * _heightScale;
					_rawVertex.push(x, scale, z, 1*Math.random()*0.5, 1*Math.random()*0.5, 1*Math.random()*0.5);
				}
			}
			//trace(_rawVertex.join(","));
		}
		
		private function generateIndices() : void
		{
			var size:uint = 6;
			for(var x:int = 0; x<_numCellsperCol-1; x++)
			{
				for(var z:int = 0; z<_numCellsPerRow-1; z++)
				{
					_rawIndex.push(x*_numCellsPerRow+z,     (x+1)*_numCellsPerRow+z,  x*_numCellsPerRow+z+1);		// (x,z), (x+1,z), (x,z+1)
					_rawIndex.push((x+1)*_numCellsPerRow+z, x*_numCellsPerRow+z+1,   (x+1)*_numCellsPerRow+z+1);	// (x+1,z), (x,z+1), (x+1, z+1)
				}
			}
			//trace(_rawIndex.join(","));
		}
	}
}