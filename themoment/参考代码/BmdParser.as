package org.g3d.parser
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.dev.utils.HexUtil;
	import org.g3d.mesh.Mesh;
	import org.g3d.mesh.SubMesh;
	import org.g3d.ns_g3d;
	import org.g3d.skeleton.Animation;
	import org.g3d.skeleton.Bone;
	import org.g3d.skeleton.KeyFrame;
	import org.g3d.skeleton.Skeleton;
	
	use namespace ns_g3d;

	public class BmdParser
	{
		static public function Parse(ba:ByteArray):Mesh
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var parser:BmdParser = new BmdParser(ba);
			parser.parse();
			return parser.mesh;
		}
		
		private var buffer:ByteArray;
		
		public var mesh:Mesh;
		private var skeleton:Skeleton;
		
		public function BmdParser(ba:ByteArray)
		{
			buffer = ba;
			
			mesh = new Mesh();
			skeleton = new Skeleton();
			
//			mesh.skeletallyAnimated = true;
			mesh.skeleton = skeleton;
		}
		
//		static private var keyList:Array = FileUtil.ParseKey("D17352F6D29ACB273EAF593137B3E7A2");
		static private const keyList:Array = [0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2];
		private function decodeBmd():void
		{
			var offset:int = 0x5E;
			
			var prevPosition:int = buffer.position;
			for(var i:int=prevPosition, n:int=buffer.length; i<n; i++){
				var byte:uint = buffer[i];
				buffer[i] = (byte ^ keyList[(i-prevPosition)%keyList.length]) - offset;
				offset = (byte + 0x3D) & 0xFF;
			}
			buffer.position = prevPosition;
		}
		
		public function parse():void
		{
			buffer.position = 4;
			switch(buffer[3]){
				case 0xA:
					break;
				case 0xC:
					buffer.readUnsignedInt();//encode part size
					decodeBmd();
					break;
				default:
					throw new Error("unsupport version:" + buffer[3]);
			}
			
			HexUtil.ReadFixedString(buffer, 32);//file name
			
			var subMeshCount:int = buffer.readUnsignedShort();//图片数量
			var boneCount:uint = buffer.readUnsignedShort();//骨骼数量
			var animationCount:int = buffer.readUnsignedShort();//动画数量
			
			var i:int;
			
			for(i=0; i<subMeshCount; i++){
				readSubMesh();
			}
			
			//trace(this, mesh.bound);
			
			for(i=0; i<animationCount; i++){
				const keyFrameCount:int = buffer.readUnsignedShort();
				var animation:Animation = new Animation(i.toString(), keyFrameCount);
				skeleton.addAnimation(animation);
				if(buffer.readUnsignedByte() > 0){
					var offset:Vector.<Vector3D> = new Vector.<Vector3D>(keyFrameCount, true);//位移
					for(var j:int=0; j<keyFrameCount; j++){
						offset[j] = new Vector3D(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
					}
					animation.offset = offset;
				}
			}
			
			for(i=0; i<boneCount; i++){
				if(buffer.readUnsignedByte() == 0){
					readBone(i);
				}
			}
			
			skeleton.onInit();
			
			if(buffer.bytesAvailable > 0){
				throw new Error("BMD数据解析失败!");
			}
		}
		
		private function readBone(id:int):void
		{
			skeleton.addBone(new Bone(HexUtil.ReadFixedString(buffer, 32), id));
			skeleton.setBoneParent(id, buffer.readShort());
			
			for(var i:int=0, n:int=skeleton.getAnimationAmount(); i<n; i++){
				readAnimation(id, skeleton.getAnimationByName(i.toString()));
			}
		}
		
		private function readAnimation(boneId:int, animation:Animation):void
		{
			const n:int = animation.length;
			var i:int;
			
			var flag:Boolean = n > 1;//复制第一桢到末尾
			
			var keyFrames:Vector.<KeyFrame> = new Vector.<KeyFrame>(n+flag, true);
			var keyFrame:KeyFrame;
			
			for(i=0; i<n; i++){
				keyFrames[i] = new KeyFrame(i);
			}
			
			if(flag){
				keyFrames[n] = new KeyFrame(n, keyFrames[0].transform);
			}
			
			for(i=0; i<n; i++){
				keyFrame = keyFrames[i];
				keyFrame.transform.translation.setTo(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
			}
			
			for(i=0; i<n; i++){
				keyFrame = keyFrames[i];
				keyFrame.transform.rotation.fromEulerAngles(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
			}
			
			animation.addTrack(boneId, keyFrames);
		}
		
		private function readVertex(n:int):Vector.<Number>
		{
			var vertexDict:Vector.<Number> = new Vector.<Number>(n*4, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 4;
				vertexDict[index] = buffer.readUnsignedShort();//boneIndex
				buffer.position += 2;
				vertexDict[index+1] = buffer.readFloat();
				vertexDict[index+2] = buffer.readFloat();
				vertexDict[index+3] = buffer.readFloat();
			}
			return vertexDict;
		}
		
		private function readNornal(n:int):Vector.<Number>
		{
			var norDict:Vector.<Number> = new Vector.<Number>(n*3, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 3;
				buffer.position += 4;//boneIndex
				norDict[index] = buffer.readFloat();
				norDict[index+1] = buffer.readFloat();
				norDict[index+2] = buffer.readFloat();
				buffer.position += 4;//第几个nor,从0开始顺序编号
			}
			return norDict;
		}
		
		private function readUV(n:int):Vector.<Number>
		{
			var uvDict:Vector.<Number> = new Vector.<Number>(n*2, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 2;
				uvDict[index] = buffer.readFloat();
				uvDict[index+1] = buffer.readFloat();
			}
			return uvDict;
		}
		
		private function readTriangle(n:int):Vector.<Vector.<int>>
		{
			var triList:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(n*3, true);
			
			for(var i:int=0; i<n; i++){//每个三角形64字节
				buffer.position += 2;
				var pos0:int = buffer.readUnsignedShort();
				var pos1:int = buffer.readUnsignedShort();
				var pos2:int = buffer.readUnsignedShort();
				buffer.position += 2;
				var nor0:int = buffer.readUnsignedShort();
				var nor1:int = buffer.readUnsignedShort();
				var nor2:int = buffer.readUnsignedShort();
				buffer.position += 2;
				var uv0:int = buffer.readUnsignedShort();
				var uv1:int = buffer.readUnsignedShort();
				var uv2:int = buffer.readUnsignedShort();
				buffer.position += 40;
				
				var index:int = i * 3;
				triList[index]   = new <int>[pos0, nor0, uv0];
				triList[index+1] = new <int>[pos1, nor1, uv1];
				triList[index+2] = new <int>[pos2, nor2, uv2];
			}
			
			return triList;
		}
		
		private function readSubMesh():void
		{
			var vetrexCount:int = buffer.readUnsignedShort();//顶点数目
			var normalCount:int = buffer.readUnsignedShort();//法线数目
			var uvCount:int = buffer.readUnsignedShort();//uv数目
			var triangleCount:uint = buffer.readUnsignedShort();//三角形数目
			buffer.readUnsignedShort();//第几个subMesh,从0开始往后编号
			
			var vertexDict:Vector.<Number> = readVertex(vetrexCount);
			var norDict:Vector.<Number> = readNornal(normalCount);
			var uvDict:Vector.<Number> = readUV(uvCount);
			var triangleDict:Vector.<Vector.<int>> = readTriangle(triangleCount);
			
			var subMesh:SubMesh = mesh.createSubMesh();
			subMesh.materialName = HexUtil.ReadFixedString(buffer, 32);
			
			var dict:Object = {};
			var item:Vector.<int>;
			var vertexIndex:int = 0;
			
			var vertexCount:uint = 0;
			
			for each(item in triangleDict){
				if(!(item.toString() in dict)){
					++vertexCount;
				}
			}
			
			subMesh.geometry = new Geometry(vertexCount);
			
			for each(item in triangleDict){
				if(!(item.toString() in dict)){
					dict[item] = vertexIndex;
					//
					var t1:int = item[0] * 4;//pos
					var t2:int = item[2] * 2;//uv
					var t3:int = item[1] * 2;//normal
					subMesh.geometry.assignBone(vertexIndex, vertexDict[t1], 1);
					subMesh.geometry.setVertex(
						vertexIndex,
						vertexDict[t1+1], vertexDict[t1+2], vertexDict[t1+3],
						uvDict[t2], uvDict[t2+1]
					);
					subMesh.geometry.setNormal(
						vertexIndex,
						norDict[t3], norDict[t3+1], norDict[t3+2]
					);
					
					++vertexIndex;
				}
			}
			
			subMesh.geometry.calculateBound(mesh.bound);
			
			subMesh.indexBuffer = new Vector.<uint>();
			
			for each(item in triangleDict){
				subMesh.indexBuffer.push(dict[item]);
			}
			
			subMesh.onInit();
		}
	}
}