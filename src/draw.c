#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "mathlib.h"
#include "AS3/AS3.h"

using namespace std;

//左手坐标系

float cam_x=0,cam_y=0,cam_z=10;		//相机位置
float ang_x=0,ang_y=PI,ang_z=0;		//观察角度

VECTOR3D cube_world[3]={
	1,1,0,
	-1,1,0,
	0,-1,0
};

VECTOR3D cube_camera[3];

void initAS3()
{
	inline_as3(
	    "import com.adobe.flascc.CModule;\n"
		"import flash.display.BitmapData;\n"
        "import flash.display.Graphics;\n"
        "import flash.display.Stage;\n"
		: :
	);
}

void AS3DrawP(int x,int y,int c)
{
	inline_as3(
		"CModule.activeConsole.bmd.setPixel32(%0, %1, %2);\n" 
		: :"r"(x), "r"(y), "r"(c)
	);
}

void initcube(){

}

//透视投影
void proj(){	
	//平移矩阵
	MATRIX4X4 Tcam_inv = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		-cam_x,-cam_y,-cam_z,1
	};
	
	//绕X轴逆旋转
	MATRIX4X4 Rcamx_inv = {
		1,0,0,0,
		0,cos(-ang_x),sin(-ang_x),0,
		0,-sin(-ang_x),cos(-ang_x),0,
		0,0,0,1
	};
	
	//绕Y轴逆旋转
	MATRIX4X4 Rcamy_inv = {
		cos(-ang_y),0,-sin(-ang_y),0,
		0,1,0,0,
		sin(-ang_y),0,cos(-ang_y),0,
		0,0,0,1
	};
	
	//绕Z轴逆旋转
	MATRIX4X4 Rcamz_inv = {
		cos(-ang_z),sin(-ang_z),0,0,
		-sin(-ang_z),cos(-ang_z),0,0,
		0,0,1,0,
		0,0,0,1
	};
	
	//计算出所有的逆矩阵，然后相乘
	MATRIX4X4 Mtemp1,Mtemp2,Tcam;
	Mat_Mul_4X4(&Tcam_inv,&Rcamy_inv,&Mtemp1);
	Mat_Mul_4X4(&Rcamx_inv,&Rcamz_inv,&Mtemp2);
	
	Mat_Mul_4X4(&Mtemp1,&Mtemp2,&Tcam);
	
	for(int vertex = 0;vertex<3;vertex++){
		Mat_Mul_VECTOR3D_4X4(&cube_world[vertex],&Tcam,&cube_camera[vertex]);
	}
	AS3DrawP(10,10,0x000000);
}

int main(){
	initAS3();
	initcube();
	proj();
	
	VECTOR3D_Print(&cube_camera[0],"p0");
	VECTOR3D_Print(&cube_camera[1],"p1");
	VECTOR3D_Print(&cube_camera[2],"p2");
	printf("我擦你大爷.");
	
	return 0;
}