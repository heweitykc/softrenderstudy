package com.core 
{
	import adobe.utils.CustomActions;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
		
	/**
	 * ...
	 * @author callee
	 */
	public class Animation 
	{
		public var isOK:Boolean = false;
		
		private var _animates:Array;
		private var _nodes:Array;
		
		private var _nodeTree:Array;
		private var _frames:Array;
		private var _loader:URLLoader
		
		public function Animation() 
		{
			
		}
		
		public function load(path:String):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest(path));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			var content:Array = (_loader.data as String).split(spliter);
			var startp:int, endp:int;
			startp = content.indexOf("nodes") + 1;
			endp = content.indexOf("end", startp);
			_nodes = content.slice(startp, endp);
			
			startp = content.indexOf("skeleton") + 1;
			endp = content.indexOf("end", startp);
			_animates = content.slice(startp, endp);
			
			trace("_nodes长度" + _nodes.length);
			trace("_animates长度" + _animates.length/(_nodes.length+1));
			
			parse();
		}
		
		private function parse():void
		{
			//build nodes
			_nodeTree = [];
			for (var i:int = 0; i < _nodes.length; i++) {
				var arr:Array = _nodes[i].split(" ");
				var nodeid:int = int(arr[0]);
				var parentid:int = int(arr[2]);
				_nodeTree[nodeid] = parentid;
			}
			
			//build animations
			_frames = [];
			var nodeLen:int = _nodes.length + 1;
			var animatelen:int = _animates.length / (_nodes.length + 1);
			for (i = 0; i < animatelen; i++) {
				var frame:Array = [];
				for (var j:int = 1; j < nodeLen; j++) {
					var framearr:Array = _animates[i * nodeLen + j].split(" ");
					nodeid = int(framearr[0]);
					var transformM:Matrix3D = new Matrix3D();
					//transformM.appendTranslation(Number(framearr[1]), Number(framearr[2]), Number(framearr[3]));
					//rotationM(Number(framearr[4]), Number(framearr[5]), Number(framearr[6]), transformM);
					
					
					var t:TransformX = new TransformX();
					t.translation.setTo(Number(framearr[1]), Number(framearr[2]), Number(framearr[3]));
					t.rotation.fromEulerAngles(Number(framearr[4]), Number(framearr[5]), Number(framearr[6]));
					t.toMatrix3D(transformM);
					
					frame[nodeid] = transformM;
				}
				//累积node的变换
				var accmulate:Array = [];
				for (var k:int = 0; k < nodeLen - 1; k++) {
					accmulate[k] = new Matrix3D;
					var ms:Array = [];
					ms.push(frame[k]);
					var parentId:int = _nodeTree[k];	//父id
					while (parentId >= 0) {
						ms.push(frame[parentId]);
						parentId = _nodeTree[parentId];
					}
					while (ms.length > 0) {
						accmulate[k].prepend(ms.pop());
					}
				}
				_frames.push(accmulate);
			}
			isOK = true;
		}
		
		private function rotationM(a:Number, b:Number, y:Number, transformM:Matrix3D):void
		{
			transformM.appendRotation(a*180/Math.PI, Vector3D.X_AXIS);
			transformM.appendRotation(b*180/Math.PI, Vector3D.Y_AXIS);
			transformM.appendRotation(y*180/Math.PI, Vector3D.Z_AXIS);
		}
		
		/*
		private function rotationM(a:Number, b:Number, y:Number):Matrix3D
		{
			var sina:Number = Math.sin(a), sinb:Number = Math.sin(b), siny:Number = Math.sin(y);
			var cosa:Number = Math.cos(a), cosb:Number = Math.cos(b), cosy:Number = Math.cos(y);
			
			var m:Matrix3D = new Matrix3D(Vector.<Number>([
				cosa*cosy-cosb*sina*siny, -cosb*cosy*sina-cosa*siny, sina*sinb, 0,
				cosy*sina+cosa*cosb*siny, cosa*cosb*cosy-sina*siny, -cosa*sinb, 0,
				sinb*siny, cosy*cosb, cosb, 0,
				0, 0, 0, 1
			]));
			
			var m:Matrix3D = new Matrix3D(Vector.<Number>([
				cosa*cosy-cosb*sina*siny, sina*cosy+cosb*cosa*siny, sinb*siny, 0,
				-cosa*siny-cosb*sina*cosy, -sina*siny+cosb*cosa*cosy, sinb*cosy, 0,
				sinb*sina, -sinb*cosa, cosb, 0,
				0, 0, 0, 0
			]));
			return m;
		}*/
		
		public function getNewVertex(x:Number,y:Number,z:Number,frame:int,boneid:int):Vector3D
		{
			var m:Matrix3D = new Matrix3D();
			m.append(_frames[frame][boneid]);
			return m.position.add(new Vector3D(x,y,z));
		}
		
		public function get len():int
		{
			return _frames.length;
		}
	}

}