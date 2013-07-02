typedef struct POLY4DV1_TYP
{
	int state;	//状态信息
	int attr;	//物理属性
	int color;	//多边形的颜色
	
	POINT4D vlist[3];		//三角形的顶点
	POINT4D tvlist[3];		//变换后的顶点
	POLYF4DV1_TYP *next;	//指向列表中下一个多边形的指针
	POLYF4DV1_TYP *prev;	//指向列表中前一个多边形的指针
} POLY4DV1, *POLY4DV1_PTR;

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

void initCube(OBJECT4DV1 *cube1);	//初始化一个cube


