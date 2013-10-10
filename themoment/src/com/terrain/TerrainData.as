package com.terrain
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class TerrainData
	{
		[Embed(source="../../../assets/heightMap.jpg",mimeType = "application/octet-stream")] 
		private const terrainData : Class;
		
		private var _heightMap:Vector.<uint>;
		private var _rawVertex:Vector.<uint>;
		private var _rawIndex:Vector.<uint>;
		
		private var uCoordIncrementSize:Number = 1.0; 	// 每列顶点数;
		private var vCoordIncrementSize:Number = 1.0; 	// 每行顶点数;
		private var _cellSpacing:Number = 1.0; 			//每行顶点数;
		private var _numVertsPerRow:int = 5; 			//顶点格式
		private var _numCellsperCol:int = 5; 			//column
		private var _numCellsPerRow:int = 5; 			//row
		
		public function TerrainData()
		{
			_heightMap = new Vector.<uint>();
			_rawVertex = new Vector.<uint>();
			_rawIndex = new Vector.<uint>();
			
			parseHeightMaps(new terrainData());
			generateVertex();
			generateIndices();
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
			var startZ:int = 0, endZ:int = 63, startX:int = 0, endX:int = 63;
			var j:int, i:int , x:int, y:int, z:int;
			for(z = startZ; z >= endZ; z -= _cellSpacing)
			{
				j = 0;
				for(x = startX; x <= endX; x += _cellSpacing)
				{
					//计算当前顶点缓冲的索引，避免死循环
					var index : int = i * _numVertsPerRow + j;
					_rawVertex.push(x,_heightMap[index],z,j * uCoordIncrementSize,i * vCoordIncrementSize);
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
			trace("索引解析完毕");
		}
	}
}