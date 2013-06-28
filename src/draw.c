#include "AS3/AS3.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "mathlib.h"
#include "drawutils.h"

using namespace std;

//左手坐标系

float cam_x=0,cam_y=0,cam_z=0;		//相机位置
float ang_x=0,ang_y=0,ang_z=0;		//观察角度

VECTOR3D m_world[3];   //世界系坐标
VECTOR3D m_camera[3];  //转换后的相机系坐标
VECTOR3D m_proj[3];  //转换后的透视坐标

int d = 10; //视距

int COLORS[] = {0x0,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF,0xFFFFFF};

VECTOR3D cube[3*8] = {
	0.8,0,20,
	-0.8,0,20,
	0,0.8,20
};

//3d转换
void proj(int color){	
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
	MATRIX4X4 Mtemp1,Mtemp2,Mtemp3,Tcam;
	Mat_Mul_4X4(&Tcam_inv,&Rcamy_inv,&Mtemp1);
	Mat_Mul_4X4(&Rcamx_inv,&Rcamz_inv,&Mtemp2);
	
	//注意顺序
	Mat_Mul_4X4(&Mtemp1,&Mtemp2,&Tcam);
	
	//世界坐标到相机坐标变化
	for(int i = 0;i<3;i++){
		Mat_Mul_VECTOR3D_4X4(&m_world[i],&Tcam,&m_camera[i]);
		
		memset(pbuff,0,1024);
		sprintf(pbuff,"(%f,%f,%f)",m_camera[i].x,m_camera[i].y,m_camera[i].z);
		p(pbuff,strlen(pbuff));
		
		float z = m_world[i].z;
		m_proj[i].x = d*m_camera[i].x/z;
		m_proj[i].y = d*m_camera[i].y/z;
	}
	
	for(int i = 0;i<3;i++){
		if(i==2){
			AS3DrawL(m_proj[i],m_proj[0],color);
		} else {
			AS3DrawL(m_proj[i],m_proj[i+1],color);
		}
	}
}

void fillTriangle(VECTOR3D& v3,float x,float y,float z)
{
	v3.x = x;
	v3.y = y;
	v3.z = z;
}

extern "C" void loop()
{
	//cube[0].z+=1;
	//cube[1].z+=1;
	//cube[2].z+=1;
	cam_z += 1;
	inline_as3(
		"import flash.geom.Rectangle;\n"
		"CModule.activeConsole.bmd.fillRect(new Rectangle(0,0,400,400), 0xffff00);\n" 
		: :
	);
	for(int i=0;i<1;i++)
	{
		fillTriangle(m_world[0],cube[i].x,cube[i].y,cube[i].z);
		fillTriangle(m_world[1],cube[i+1].x,cube[i+1].y,cube[i+1].z);
		fillTriangle(m_world[2],cube[i+2].x,cube[i+2].y,cube[i+2].z);
		proj(COLORS[i]);
	}	
}

int main(){
	return 0;
}