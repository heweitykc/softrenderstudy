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
		
		public function load(name:String="Monster33"):void
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
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			_content = (_loader.data as String).split(spliter);
			
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
					_meshs[key].submesh.scale = 1;
					_meshs[key].img = "assets/" + _name + "/" + key;
					_meshs[key].submesh.img = _meshs[key].img;
				}
			}
		}
		
		private var _frame:int=0;
		public function render():void
		{
			if (!_ok) return;
			for each(var mesh:Object in _meshs) {
				mesh.submesh.render(_frame);
			}
			_frame++;
			//trace("---------------");
		}
		
		public function test():void
		{
			var v:Vector3D = new Vector3D();
			var m:Matrix3D = new Matrix3D();
			m.position = new Vector3D(100, 100, 100);
			//m.appendTranslation(100, 100, 100);
			m.appendRotation(90, Vector3D.X_AXIS);
			v.incrementBy(m.position);
			trace(v.x+","+v.y+","+v.z);
		}
	}

}