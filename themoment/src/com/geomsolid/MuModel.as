package com.geomsolid 
{
	import adobe.utils.CustomActions;
	import com.core.*;
	import flash.display3D.Context3D;
	import flash.events.*;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.*;
	import flash.utils.ByteArray;
	import com.misc.*;
	
	/**
	 * ...
	 * @author callee
	 */
	public class MuModel
	{
		private var _context3d:Context3D;
		private var _loader:URLLoader;
		private var _content:Array;
		private var _ok:Boolean = false;
		private var _meshs:Object;
		private var _name:String;
		protected var _animation:Animation;
		
		public function MuModel(context3d:Context3D)
		{
			_context3d = context3d;
			test();
		}
		
		public function load(name:String="Monster32"):void
		{
			_name = name;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest("assets/"+name + "/" + name + ".smd"));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
						
			_animation = new Animation();
			_animation.load("assets/"+name + "/" + name + "_001.smd");
		}
		public function get animation():Animation
		{
			return _animation;
		}
		
		private function parsePose():void
		{
			var startp:int, endp:int, nodes:Array, animates:Array;
			startp = _content.indexOf("nodes") + 1;
			endp = _content.indexOf("end", startp);
			nodes = _content.slice(startp, endp);
			
			startp = _content.indexOf("skeleton") + 1;
			endp = _content.indexOf("end", startp);
			animates = _content.slice(startp, endp);
			
			var _nodeTree:Array = [];
			for (var i:int = 0; i < nodes.length; i++) {
				var arr:Array = nodes[i].split(" ");
				var boneid:int = int(arr[0]);
				var parentid:int = int(arr[2]);
				_nodeTree[boneid] = parentid;
			}
			animation.NodeTree = _nodeTree;
			
			var _firstF:Array = [];
			
			for (var j:int = 1; j < nodes.length + 1; j++) {
				var frame:Array = [];
				var framearr:Array = animates[j].split(" ");
				var m:Matrix3D = MathUtil.rotate(
					Number(framearr[1]), Number(framearr[2]), Number(framearr[3]),
					Number(framearr[4]), Number(framearr[5]), Number(framearr[6])
				);
				_firstF[int(framearr[0])] = m;
			}
			
			//累积node的变换
			for (boneid = 0; boneid < nodes.length; boneid++) {
				var parentId:int = _nodeTree[boneid];	//由于节点是从小到大顺序的，父节点肯定是已经累加过的
				if (parentId > -1)
					_firstF[boneid].prepend(_firstF[parentId]);
			}
			
			_animation.Pose = _firstF;
		}
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			_content = (_loader.data as String).split(spliter);
			
			parsePose();
			
			var startp:int = _content.indexOf("triangles") + 1;
			var endp:int = _content.indexOf("end", startp);
			computeSubMesh(startp, endp);
			
			var index:int = 0;
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				var p0:Array = _content[i+1].split(" ");
				var p1:Array = _content[i + 2].split(" ");
				
				var p2:Array = _content[i + 3].split(" ");

				_meshs[key].submesh.bones.push(int(p0[0]));	//顶点对应的关节
				_meshs[key].submesh.bones.push(int(p1[0]));	//顶点对应的关节
				_meshs[key].submesh.bones.push(int(p2[0]));	//顶点对应的关节
				
				_meshs[key].vertex.push(Number(p0[1]), Number(p0[2]), Number(p0[3]),  Number(p0[7]), 1-Number(p0[8]));
				_meshs[key].vertex.push(Number(p1[1]), Number(p1[2]), Number(p1[3]),  Number(p1[7]), 1-Number(p1[8]));
				_meshs[key].vertex.push(Number(p2[1]), Number(p2[2]), Number(p2[3]),  Number(p2[7]), 1-Number(p2[8]));
				
				var idx:int = _meshs[key].index.length;
				_meshs[key].index.push(idx, idx + 1, idx + 2);
				index++;
			}
			
			for each(var mesh:Object in _meshs) {
				var sub:SubMeshBase = mesh.submesh;
				sub.upload(mesh.vertex, mesh.index);
				trace(sub.img + ",顶点" + mesh.vertex.length/5 + ";bones=" + sub.bones.length);
			}
			
			_ok = true;
		}
		
		private function computeSubMesh(startp:int, endp:int):void
		{
			_meshs = { };
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				if (!_meshs[key]) {
					_meshs[key] = { };
					_meshs[key].vertex =  new Vector.<Number>();
					_meshs[key].index =  new Vector.<uint>();
					_meshs[key].submesh = new SubMeshBase(_context3d,this);
					_meshs[key].submesh.scale = 0.02;
					_meshs[key].img = "assets/" + _name + "/" + key;
					_meshs[key].submesh.img = _meshs[key].img;
				}
			}
		}
		
		public function render(frame:int):void
		{
			if (!_ok) return;
			for each(var mesh:Object in _meshs) {
				mesh.submesh.render(frame);
			}
			trace("---------------");
		}
		
		public function test():void
		{
			var v:Vector3D = new Vector3D();
			var m:Matrix3D = new Matrix3D();
			var vp = [0.000000, -6.875042, 202.009552];
			var vr = [0.000000, -0.008727, -1.570795];
			m.appendRotation(vr[0],Vector3D.X_AXIS);
			m.appendRotation(vr[1],Vector3D.Y_AXIS);
			m.appendRotation(vr[2], Vector3D.Z_AXIS);
			//m.appendTranslation(vp[0], vp[1], vp[2]);
		}
	}

}