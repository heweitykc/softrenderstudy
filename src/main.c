#include "AS3/AS3.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "xml/tinyxml2.h"
#include "mathlib.h"
#include "drawdef.h"
#include "drawutils.h"

using namespace tinyxml2;

//左手坐标系

float cam_x=0,cam_y=0,cam_z=-20;		//相机位置
float ang_x=0,ang_y=0,ang_z=0;		//观察角度

VECTOR3D m_world[3];   //世界系坐标
VECTOR3D m_camera[3];  //转换后的相机系坐标
VECTOR3D m_proj[3];  //转换后的透视坐标

float rotationX=0;
float rotationY=0;
float rotationZ=0;

int d = 10; //视距				

int COLORS[] = {0x0,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF,0xFFFFFF};

XMLDocument doc;

VECTOR3D cube2[] = {
	0,0,0+20,		//0
	1.0,0,0+20,		//1
	1.0,1.0,0+20,	//2
	0,1.0,0+20,		//3
	0,1.0,1.0+20,	//4
	0,0,1.0+20,		//5
	1.0,0,1.0+20,	//6
	1.0,1.0,1.0+20	//7
};

int cubeIndex[] = {
	0,1,3,1,3,2,
	1,6,2,6,2,7,
	6,5,7,5,7,4,
	0,5,3,5,3,4,
	3,2,4,2,4,7,
	0,1,5,1,5,6
};

OBJECT4DV1 obj;

MATRIX4X4 m_rotation = {		
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1
};
VECTOR3D rotation0 = {0.5,1,0.5+20};   //竖轴
VECTOR3D rotation1 = {0.5,0,0.5+20};

VECTOR3D rotation2 = {0,1.0,0+20};   //横轴
VECTOR3D rotation3 = {1.0,0,1+20};

MATRIX4X4 Tcam;

void translate()
{
	//平移矩阵,与相机原点重合
	MATRIX4X4 Tcam_inv = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		-cam_x,-cam_y,-cam_z,1
	};
	
	//绕X轴逆旋转, 与相机x轴重合
	MATRIX4X4 Rcamx_inv = {
		1,0,0,0,
		0,cos(-ang_x),sin(-ang_x),0,
		0,-sin(-ang_x),cos(-ang_x),0,
		0,0,0,1
	};
	
	//绕Y轴逆旋转, 与相机y轴重合
	MATRIX4X4 Rcamy_inv = {
		cos(-ang_y),0,-sin(-ang_y),0,
		0,1,0,0,
		sin(-ang_y),0,cos(-ang_y),0,
		0,0,0,1
	};
	
	//绕Z轴逆旋转, 与相机z轴重合
	MATRIX4X4 Rcamz_inv = {
		cos(-ang_z),sin(-ang_z),0,0,
		-sin(-ang_z),cos(-ang_z),0,0,
		0,0,1,0,
		0,0,0,1
	};
	
	//计算出所有的逆矩阵，然后相乘
	MATRIX4X4 Mtemp1,Mtemp2;
	Mat_Mul_4X4(&Tcam_inv,&Rcamy_inv,&Mtemp1);
	Mat_Mul_4X4(&Rcamx_inv,&Rcamz_inv,&Mtemp2);
	
	//注意顺序
	Mat_Mul_4X4(&Mtemp1,&Mtemp2,&Tcam);
}

//3d转换
void proj(int color){
	VECTOR3D v_camera2;
	//世界坐标到相机坐标变化
	for(int i = 0;i<3;i++){
		Mat_Mul_VECTOR3D_4X4(&m_world[i],&m_rotation,&m_camera[i]);//乘上绕XYZ轴的旋转矩阵
		Mat_Mul_VECTOR3D_4X4(&m_camera[i],&Tcam,&v_camera2);
		
		//memset(pbuff,0,1024);
		//sprintf(pbuff,"(%f,%f,%f)",v_camera2.x,v_camera2.y,v_camera2.z);
		//p(pbuff,strlen(pbuff));
		
		float z = v_camera2.z;
		m_proj[i].x = d*v_camera2.x/z;
		m_proj[i].y = d*v_camera2.y/z;
	}
	
	for(int i = 0;i<3;i++){
		if(i==2){
			AS3DrawL(m_proj[i],m_proj[0],color);
		} else {
			AS3DrawL(m_proj[i],m_proj[i+1],color);
		}
	}
}

//读取dae文件
void loadmodel()
{
	doc.LoadFile("1.dae");
	initObjWithDae(&obj,&doc);
}

//args: up,down,left,right
extern "C" void loop(int args[])
{
	int inup,indown,inleft,inright;
	inline_as3("var num:Number;");
	inline_as3("num = CModule.activeConsole.inUp;");
    AS3_GetScalarFromVar(inup, num);
	inline_as3("num = CModule.activeConsole.inDown;");
    AS3_GetScalarFromVar(indown, num);
	inline_as3("num = CModule.activeConsole.inLeft;");
    AS3_GetScalarFromVar(inleft, num);
	inline_as3("num = CModule.activeConsole.inRight;");
    AS3_GetScalarFromVar(inright, num);
	
	inline_as3(
		"import flash.geom.Rectangle;\n"
		"CModule.activeConsole.bmd.fillRect(new Rectangle(0,0,400,400), 0xffff00);\n" 
		: :
	);
	
	if(inup == 1){
		cam_z += 0.1;
	}
	if(indown == 1){
		cam_z -= 0.1;
	}
	if(inleft == 1){
		cam_x -= 0.1;
	}
	if(inright == 1){
		cam_x += 0.1;
	}
	
	rotationZ += (1.0/180.0*PI);
	RotateArbitraryLine(&m_rotation,&rotation2,&rotation3,rotationZ);
	translate();
	int len = sizeof(cubeIndex) / sizeof(cubeIndex[0]);
	for(int i=0;i<len;i+=3)
	{	
		fillTriangle(m_world[0],cube2[cubeIndex[i]]);
		fillTriangle(m_world[1],cube2[cubeIndex[i+1]]);
		fillTriangle(m_world[2],cube2[cubeIndex[i+2]]);
		proj(0);
	}	
}

int main(){
	printf("starting...");
	loadmodel();
	return 0;
}