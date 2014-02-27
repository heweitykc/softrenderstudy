package com.parser 
{
	import flash.utils.*;
	import com.misc.HexUtil;
	
	/**
	 * ...
	 * @author callee
	 */
	public class BmdParser {
		static private const keyList:Array = [0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2];
		
		private var _buffer:ByteArray;
		
		public function BmdParser() 
		{
			
		}
		
		private function decodeBmd():void
		{
			var offset:int = 0x5E;
			
			var prevPosition:int = _buffer.position;
			for(var i:int=prevPosition, n:int=_buffer.length; i<n; i++){
				var byte:uint = _buffer[i];
				_buffer[i] = (byte ^ keyList[(i-prevPosition)%keyList.length]) - offset;
				offset = (byte + 0x3D) & 0xFF;
			}
			_buffer.position = prevPosition;
		}
		
		public function parse(bts:ByteArray):void
		{
			_buffer = bts;
			switch(_buffer[3]){
				case 0xA:
					break;
				case 0xC:
					_buffer.readUnsignedInt();//encode part size
					decodeBmd();
					break;
				default:
					throw new Error("unsupport version:" + _buffer[3]);
			}
			trace(HexUtil.ReadFixedString(_buffer, 32));
			
			var subMeshCount:int = _buffer.readUnsignedShort();		//图片数量
			var boneCount:uint = _buffer.readUnsignedShort();		//骨骼数量
			var animationCount:int = _buffer.readUnsignedShort();	//动画数量
			
			trace("subMeshCount=" + subMeshCount);
			trace("boneCount=" + boneCount);
			trace("animationCount="+animationCount);
			
			var i:int;
			for(i=0; i<subMeshCount; i++){
				readSubMesh();
			}
		}
		
		private function readSubMesh():void
		{
			var vetrexCount:int = _buffer.readUnsignedShort();//顶点数目
			var normalCount:int = _buffer.readUnsignedShort();//法线数目
			var uvCount:int = _buffer.readUnsignedShort();//uv数目
			var triangleCount:uint = _buffer.readUnsignedShort();//三角形数目
			_buffer.readUnsignedShort();//第几个subMesh,从0开始往后编号
			
			var vertexDict:Vector.<Number> = readVertex(vetrexCount);
			var norDict:Vector.<Number> = readNormal(normalCount);
			var uvDict:Vector.<Number> = readUV(uvCount);
			var triangleDict:Vector.<Vector.<int>> = readTriangle(triangleCount);
			
			trace(HexUtil.ReadFixedString(_buffer, 32));
			
			var dict:Object = {};
			var item:Vector.<int>;
			var vertexIndex:int = 0;
			
			var vertexCount:uint = 0;
			
			for each(item in triangleDict){
				if(!(item.toString() in dict)){
					++vertexCount;
				}
			}
		}
		
		private function readVertex(n:int):Vector.<Number>
		{
			var vertexDict:Vector.<Number> = new Vector.<Number>(n*4, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 4;
				vertexDict[index] = _buffer.readUnsignedShort();//boneIndex
				_buffer.position += 2;
				vertexDict[index+1] = _buffer.readFloat();
				vertexDict[index+2] = _buffer.readFloat();
				vertexDict[index+3] = _buffer.readFloat();
			}
			return vertexDict;
		}
		
		private function readNormal(n:int):Vector.<Number>
		{
			var norDict:Vector.<Number> = new Vector.<Number>(n*3, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 3;
				_buffer.position += 4;//boneIndex
				norDict[index] = _buffer.readFloat();
				norDict[index+1] = _buffer.readFloat();
				norDict[index+2] = _buffer.readFloat();
				_buffer.position += 4;//第几个nor,从0开始顺序编号
			}
			return norDict;
		}
		
		private function readUV(n:int):Vector.<Number>
		{
			var uvDict:Vector.<Number> = new Vector.<Number>(n*2, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 2;
				uvDict[index] = _buffer.readFloat();
				uvDict[index+1] = _buffer.readFloat();
			}
			return uvDict;
		}
		
		private function readTriangle(n:int):Vector.<Vector.<int>>
		{
			var triList:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(n*3, true);
			
			for(var i:int=0; i<n; i++){//每个三角形64字节
				_buffer.position += 2;
				var pos0:int = _buffer.readUnsignedShort();
				var pos1:int = _buffer.readUnsignedShort();
				var pos2:int = _buffer.readUnsignedShort();
				_buffer.position += 2;
				var nor0:int = _buffer.readUnsignedShort();
				var nor1:int = _buffer.readUnsignedShort();
				var nor2:int = _buffer.readUnsignedShort();
				_buffer.position += 2;
				var uv0:int = _buffer.readUnsignedShort();
				var uv1:int = _buffer.readUnsignedShort();
				var uv2:int = _buffer.readUnsignedShort();
				_buffer.position += 40;
				
				var index:int = i * 3;
				triList[index]   = new <int>[pos0, nor0, uv0];
				triList[index+1] = new <int>[pos1, nor1, uv1];
				triList[index+2] = new <int>[pos2, nor2, uv2];
			}
			
			return triList;
		}
	}

}