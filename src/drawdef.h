#ifndef DRAWDEF_H
#define DRAWDEF_H

#include "main.h"

using namespace tinyxml2;

typedef struct POLY4DV1_TYP
{
	int state;
	int attr;
	int color;
	
	POINT4D_PTR vlist;	//顶点列表
	int vert[3];		//索引
} POLY4DV1, *POLY4DV1_PTR;

typedef struct POLYF4DV1_TYP
{
	int state;	//状态信息
	int attr;	//物理属性
	int color;	//多边形的颜色
	
	POINT4D vlist[3];		//三角形的顶点
	POINT4D tvlist[3];		//变换后的顶点
	POLYF4DV1_TYP *next;	//指向列表中下一个多边形的指针
	POLYF4DV1_TYP *prev;	//指向列表中前一个多边形的指针
} POLYF4DV1, *POLYF4DV1_PTR;

typedef struct OBJECT4DV1_TYP
{
	int id;			//物体的数值id	
	char name[64];	//物体的字符串名称
	int state;		//状态
	int attr;		//属性
	float avg_radius;	//半径，碰撞检测
	float max_radius;	//最大半径
	
	POINT4D world_pos;	//物体在世界坐标系中的位置
	
	VECTOR4D dir;		//物体在局部坐标系的旋转角度
	
	VECTOR4D ux,uy,uz;	//物体朝向???
	
	int num_vertices;	//物体的顶点数

	POINT4D vlist_local[64];	//物体局部坐标
	POINT4D vlist_trans[64];	//顶点变换后的坐标
	
	int num_polys;			//物体的多边形数
	POLY4DV1 plist[128];	//存储多边形的数组
} OBJECT4DV1, *OBJECT4DV1_PTR;

typedef struct CAM4DV1_TYP
{
	int state;
	int attr;
	
	POINT4D pos;	//相机在世界坐标系的位置
	
	VECTOR4D dir;	//欧拉角度或者UVN相机模型的注视方向
	VECTOR4D u;		//UVN相机模型的朝向向量
	VECTOR4D v;
	VECTOR4D n;
	POINT4D target;	//UVN模型的目标位置
	
	float view_dist_h;	//水平视距和垂直视距
	float view_dist_v;
	
	float fov;	//水平方向和垂直方向的视野
	
	float near_clip_z;	//近裁剪面
	float far_clip_z;	//远裁剪面
	
	PLANE3D rt_clip_plane;	//右剪裁面
	PLANE3D lt_clip_plane;	//左剪裁面
	PLANE3D tp_clip_plane;	//上剪裁面
	PLANE3D bt_clip_plane;	//下剪裁面
	
	float viewplane_width;		//视平面的宽度和高度
	float viewplane_height;		//对于归一化投影,为2X2，否则大小与视口或者屏幕相同
	
	//屏幕与视口是同义词
	float viewport_width;		//屏幕/视口的大小
	float viewport_height;		//
	float viewport_center_x;	// 视口的中心
	float viewport_center_y;	//
	
	float aspect_ratio;	//屏幕的宽高比
	
	MATRIX4X4 mcam;		//用于存储世界坐标到相机坐标变换矩阵
	MATRIX4X4 mper;		//用于存储相机坐标到透视坐标变换矩阵
	MATRIX4X4 mscr;		//用于存储透视坐标到屏幕坐标变换矩阵
} CAM4DV1, *CAM4DV1_PTR;

void initCube(OBJECT4DV1 *cube1);	//初始化一个cube
void initObjWithDae(OBJECT4DV1 *obj1, XMLDocument *doc);
char* getSourceName(const char *source2);	//获取source名称

void write_vs(POINT4D_PTR p, int len);
void write_obj4dv(OBJECT4DV1 *obj);

#endif