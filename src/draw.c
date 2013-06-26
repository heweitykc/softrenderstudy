#include "AS3/AS3.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "mathlib.h"

using namespace std;

//左手坐标系

float cam_x=0,cam_y=0,cam_z=10;		//相机位置
float ang_x=0,ang_y=PI,ang_z=0;		//观察角度
char pbuff[1024];

VECTOR3D cube_world[3]={
	0.8,0.8,0,
	-0.8,0.8,0,
	0,-0.8,0
};

VECTOR3D cube_camera[3];

void p(char* str, int len)
{
    AS3_DeclareVar(myString, String);
    AS3_CopyCStringToVar(myString, str, len);
    AS3_Trace(myString);
}

float XX(float x)
{
	return (x+1)/2 * 400;	
}
float YY(float y)
{
	return (y+1)/2 * 300;	
}

void initAS3()
{
	inline_as3(
	    "import com.adobe.flascc.CModule;\n"
		"import flash.display.BitmapData;\n"
        "import flash.display.Graphics;\n"
        "import flash.display.Stage;\n"
		"import flash.geom.Rectangle;\n"
		: :
	);
}

void AS3DrawP(float x,float y,int c)
{
	//memset(pbuff,0,1024);
	//sprintf(pbuff,"x=%f,y=%f",x,y);
	//p(pbuff,strlen(pbuff));
	
	inline_as3(
		"CModule.activeConsole.bmd.setPixel32(%0, %1, %2);\n" 
		"CModule.activeConsole.bmd.setPixel32(%0, %1+1, %2);\n" 
		"CModule.activeConsole.bmd.setPixel32(%0+1, %1, %2);\n" 
		"CModule.activeConsole.bmd.setPixel32(%0+1, %1+1, %2);\n" 
		: :"r"(int(x)), "r"(int(y)), "r"(c)
	);
}

void AS3DrawL(float x1,float y1,float x2,float y2,int c)
{
	memset(pbuff,0,1024);
	sprintf(pbuff,"x1=%f,y1=%f,x2=%f,y2=%f",x1,y1,x2,y2);
	p(pbuff,strlen(pbuff));
	
float k,dx,dy,x,y,xend,yend;
dx = x2 - x1;
dy = y2 - y1;
if(fabs(dx) >= fabs(dy))
{
k = dy / dx;
if(dx > 0)
{
x = x1;
y = y1;
xend = x2;
}
else
{
x = x2;
y = y2;
xend = x1;
}
while(x <= xend)
{
AS3DrawP(x, y, c);
y = y + k;
x = x + 1;
}
}
else
{
k = dx / dy;
if(dy > 0)
{
x = x1;
y = y1;
yend = y2;
}
else
{
x = x2;
y = y2;
yend = y1;
}
while(y <= yend)
{
AS3DrawP(x, y, c);
x = x + k;
y = y + 1;
}
}
}

void initcube(){

}

//3d转换
void proj(){	
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
	
	Mat_Mul_4X4(&m0,&Mtemp2,&Mtemp3);
	
	Mat_Mul_4X4(&Mtemp1,&Mtemp3,&Tcam);
	
	for(int i = 0;i<3;i++){
		Mat_Mul_VECTOR3D_4X4(&cube_world[i],&Tcam,&cube_camera[i]);
	}
	for(int i = 0;i<3;i++){
		if(i==2){
			AS3DrawL(XX(cube_camera[i].x),YY(cube_camera[i].y),XX(cube_camera[0].x),YY(cube_camera[0].y),0);
		} else {
			AS3DrawL(XX(cube_camera[i].x),YY(cube_camera[i].y),XX(cube_camera[i+1].x),YY(cube_camera[i+1].y),0);
		}
	}
}

extern "C" void loop()
{
	//cam_y+=0.01;
	
	memset(pbuff,0,1024);
	sprintf(pbuff,"ry=%f",ry);
	p(pbuff,strlen(pbuff));
	inline_as3(
		"import flash.geom.Rectangle;\n"
		"CModule.activeConsole.bmd.fillRect(new Rectangle(0,0,400,300), 0xffffff);\n" 
		: :
	);
	proj();
}

int main(){
	initAS3();
	initcube();
	return 0;
}