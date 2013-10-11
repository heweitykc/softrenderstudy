package com.terrain
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class TerrainData
	{
		[Embed(source="../../../assets/heightMap.jpg",mimeType = "application/octet-stream")] 
		private const terrainData : Class;
		
		private var _heightMap:Vector.<uint>;
		private var _rawVertex:Vector.<Number>;
		private var _rawIndex:Vector.<uint>;
		
		private var uCoordIncrementSize:Number = 1.0; 	// 每列顶点数;
		private var vCoordIncrementSize:Number = 1.0; 	// 每行顶点数;
		private var _cellSpacing:Number = 1.0; 			//每行顶点数;
		private var _numVertsPerRow:int = 6; 			//顶点格式
		
		private var _numCellsperCol:int = 2; 			//column
		private var _numCellsPerRow:int = 2; 			//row
		private var _heightScale:Number = 1/256;
		
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
			var startZ:int = 0, endZ:int = _numCellsperCol, startX:int = 0, endX:int = _numCellsPerRow;
			var j:int, i:int , x:int = 1, y:int = 1, z:int = 0;
			trace("顶点开始：");
			for(z = startZ; z <= endZ; z += _cellSpacing)
			{
				j = 0;
				for(x = startX; x <= endX; x += _cellSpacing)
				{
					//计算当前顶点缓冲的索引，避免死循环
					var index : int = i * _numVertsPerRow + j;
					_rawVertex.push(x/endX,	_heightMap[index]*_heightScale,	0,	1, 1, 1);
					trace("x="+(x/endX)+",y="+_heightMap[index]*_heightScale+",z="+0);
					j++;
				}
				i++;
			}
		}
		
		private function generateIndices() : void
		{
			var baseIndex : int = 0;
			
			for(var i:int = 0; i<_numCellsperCol; i++)
			{
				for(var j:int = 0; j<_numCellsPerRow; j++)
				{
					_rawIndex[baseIndex]       = i * _numVertsPerRow + j;
					_rawIndex[baseIndex + 1]   = i * _numVertsPerRow + j + 1;
					_rawIndex[baseIndex + 2]   = (i + 1) * _numVertsPerRow + j;
					
					_rawIndex[baseIndex + 3]   = (i + 1) * _numVertsPerRow + j;
					_rawIndex[baseIndex + 4]   = i * _numVertsPerRow + j + 1;
					_rawIndex[baseIndex + 5]   = (i + 1) * _numVertsPerRow + j + 1;
					
					baseIndex += 6;
				}
			}
			trace(_rawIndex.join(","));
			trace("索引解析完毕");
		}
	}
}