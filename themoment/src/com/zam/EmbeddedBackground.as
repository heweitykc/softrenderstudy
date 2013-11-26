package com.zam
{
	import com.zam.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.geom.*;
	

    public class EmbeddedBackground extends Shader implements IBackground
    {
        protected var bitmap:Bitmap;
        protected var texture:Texture;
        protected var ready:Boolean;
        protected var orthoMatrix:Matrix3D;
        protected var mvpMatrix:Matrix3D;
        protected var vb:VertexBuffer3D;
        protected var ib:IndexBuffer3D;

        public function EmbeddedBackground(param1:Viewer, param2:Bitmap)
        {
            super(param1);
            this.bitmap = param2;
            this.mvpMatrix = new Matrix3D();
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_1:* = viewer.stage.stageWidth;
            var _loc_2:* = viewer.stage.stageHeight;
            var _loc_3:* = this.bitmap.width;
            var _loc_4:* = this.bitmap.height;
            var _loc_5:* = 1;
            var _loc_6:* = -1;
            this.orthoMatrix = new Matrix3D(this.Vector.<Number>([2 / _loc_1, 0, 0, 0, 0, -2 / _loc_2, 0, 0, 0, 0, 1 / (_loc_5 - _loc_6), (-_loc_6) / (_loc_5 - _loc_6), 0, 0, 0, 1]));
            this.mvpMatrix.identity();
            this.mvpMatrix.appendTranslation((-_loc_1) / 2, (-_loc_2) / 2, 0);
            this.mvpMatrix.appendScale(1, -1, 1);
            this.mvpMatrix.append(this.orthoMatrix);
            var _loc_7:* = this.Vector.<Number>([0, 0, 0, 0, _loc_2 / _loc_4, _loc_1, 0, 0, _loc_1 / _loc_3, _loc_2 / _loc_4, 0, _loc_2, 0, 0, 0, _loc_1, _loc_2, 0, _loc_1 / _loc_3, 0]);
            var _loc_8:* = this.Vector.<uint>([0, 1, 2, 2, 1, 3]);
            if (this.texture)
            {
                this.texture.dispose();
            }
            this.texture = context.createTexture(this.bitmap.width, this.bitmap.height, Context3DTextureFormat.BGRA, false);
            this.texture.uploadFromBitmapData(this.bitmap.bitmapData);
            if (this.vb)
            {
                this.vb.dispose();
            }
            this.vb = viewer.context.createVertexBuffer(4, 5);
            this.vb.uploadFromVector(_loc_7, 0, 4);
            if (this.ib)
            {
                this.ib.dispose();
            }
            this.ib = viewer.context.createIndexBuffer(6);
            this.ib.uploadFromVector(_loc_8, 0, 6);
            upload();
            return;
        }// end function

        public function render() : void
        {
            if (!this.ready)
            {
                if (this.bitmap)
                {
                    this.refresh();
                    upload();
                    this.ready = true;
                }
                else
                {
                    return;
                }
            }
            context.setProgram(program);
            context.setDepthTest(false, Context3DCompareMode.ALWAYS);
            context.setCulling(Context3DTriangleFace.NONE);
            context.setProgramConstantsFromMatrix("vertex", 0, this.mvpMatrix, true);
            context.setVertexBufferAt(0, this.vb, 0, "float3");
            context.setVertexBufferAt(1, this.vb, 3, "float2");
            context.setVertexBufferAt(2, null);
            context.setVertexBufferAt(3, null);
            context.setVertexBufferAt(4, null);
            context.setTextureAt(0, this.texture);
            context.setTextureAt(1, null);
            context.setTextureAt(2, null);
            context.setTextureAt(3, null);
            context.drawTriangles(this.ib, 0, 2);
            context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            op("mov v0, va1");
            op("m44 op, va0, vc0");
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            op("tex oc, v0, fs0 <2d,repeat,linear>");
            return;
        }// end function

    }
}
