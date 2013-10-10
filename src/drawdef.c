#include "drawdef.h"
#include <string.h>

void initCube(OBJECT4DV1 *cube1)
{
	cube1->id = 0;
	cube1->state = 0;
	cube1->attr = 0;
	
	cube1->avg_radius = 17.3;
	cube1->max_radius = 17.3;
	
	cube1->world_pos.x = 0;
	cube1->world_pos.y = 0;
	cube1->world_pos.z = 0;
	
	cube1->dir.x = 0;
	cube1->dir.y = 0;
	cube1->dir.z = 0;
	cube1->num_vertices = 8;
	
	POINT3D temp_verts[8] = {
		{10,10,10},
		{10,10,-10},
		{-10,10,-10},
		{-10,10,10},
		{10,-10,10},
		{-10,-10,10},
		{-10,-10,-10},
		{10,-10,-10}
	};
	
	for(int vertex=0; vertex<8; vertex++)
	{
		cube1->vlist_local[vertex].x = temp_verts[vertex].x;
		cube1->vlist_local[vertex].y = temp_verts[vertex].y;
		cube1->vlist_local[vertex].z = temp_verts[vertex].z;
		cube1->vlist_local[vertex].w = 1;
	}
	cube1->num_polys = 12;
	int temp_poly_indices[12*3] = {
		0,1,2,	0,2,3,
		0,7,1,	0,4,7,
		1,7,6,	1,6,2,
		2,6,5,	2,3,5,
		0,5,4,	0,3,5,
		5,6,7,	4,5,7
	};
	
	for(int tri=0;tri<12;tri++)
	{
		cube1->plist[tri].state = 0;
		cube1->plist[tri].attr = 0;
		cube1->plist[tri].color = 0;
		
		cube1->plist[tri].vlist = cube1->vlist_local;
		
		cube1->plist[tri].vert[0] = temp_poly_indices[tri*3+0];
		cube1->plist[tri].vert[1] = temp_poly_indices[tri*3+1];
		cube1->plist[tri].vert[2] = temp_poly_indices[tri*3+2];
	}
}

//解析dae
void initObjWithDae(OBJECT4DV1 *obj1, XMLDocument *doc)
{
	tinyxml2::XMLElement *rootElement = doc->FirstChildElement("COLLADA");
	
	//顶点解析
	//遍历几何体
	tinyxml2::XMLElement *geometryElement = rootElement->FirstChildElement("library_geometries")->FirstChildElement("geometry");	
	int index = 0; //几何体索引

	while(geometryElement){
		tinyxml2::XMLElement *verticesElement = geometryElement->FirstChildElement("mesh")->FirstChildElement("vertices");
		tinyxml2::XMLElement *inputElement = verticesElement->FirstChildElement("input");
		printf("start index = %d\n",index);
		if(strcmp(inputElement->Attribute("semantic"),"POSITION") == 0){
			inputElement = geometryElement->FirstChildElement("mesh")->FirstChildElement("source")->FirstChildElement("float_array");
			const char* tempchr2 = inputElement->GetText();
			char *pch = strtok((char*)tempchr2, " ");
			int i = 0;
			while(pch != NULL){
				obj1->vlist_local[i/3].M[i%3] = atof(pch);
				pch = strtok(NULL," ");
				i++;
			}
			obj1->num_vertices = i/3;			
			
			inputElement = geometryElement->FirstChildElement("mesh")->FirstChildElement("polylist")->FirstChildElement("p");
			const char* tempchr3 = inputElement->GetText();
			pch = strtok((char*)tempchr3, " ");
			i=0;
			while(pch != NULL){
				if(i%2 == 0){
					obj1->plist[i/6].vert[(i%6)/2] = atoi(pch);
				}
				pch = strtok(NULL," ");
				i++;
			}
			obj1->num_polys = i/6;
			index++;
		}
		write_obj4dv(obj1);
		//geometryElement = geometryElement->NextSiblingElement("geometry");
		geometryElement = NULL;
	}
}

char* getSourceName(const char *source2)
{
	int len = strlen(source2)+1;
	char *sourceName = (char*)malloc(len);	
	strncpy(sourceName, source2+1, len);
	return sourceName;
}

void write_obj4dv(OBJECT4DV1 *obj)
{
	printf("num_vertices=%d\n",obj->num_vertices);
	for(int i=0;i<obj->num_vertices;i++)
	{
		printf("vertex[%d]:{%0f,%0f,%0f}\n", i, obj->vlist_local[i].x, obj->vlist_local[i].y, obj->vlist_local[i].z);
	}
	printf("num_polys=%d\n",obj->num_polys);
	for(int i=0;i<obj->num_polys;i++)
	{
		printf("index[%d]:{%d,%d,%d}\n",i,obj->plist[i].vert[0],obj->plist[i].vert[1],obj->plist[i].vert[2]);
	}
}

void Init_CAM4DV1(
		CAM4DV1_PTR cam,			//相机对象
		int cam_attr,				//相机属性
		POINT4D_PTR cam_pos,		//相机的初始位置
		VECTOR4D_PTR cam_dir,		//相机的初始角度
		POINT4D_PTR cam_target,		//UVN相机的初始目标位置
		float near_clip_z,			//近剪裁面和远剪裁面
		float far_clip_z,
		float fov,					//视野，单位为度
		float viewport_width,		//屏幕/视口的大小
		float viewport_height)
{
	cam->attr = cam_attr;
	VECTOR4D_COPY(&cam->pos,cam_pos);
	VECTOR4D_COPY(&cam->dir,cam_dir);

	VECTOR4D_INITXYZ(&cam->u, 1,0,0);
	VECTOR4D_INITXYZ(&cam->v, 0,1,0);
	VECTOR4D_INITXYZ(&cam->n, 0,0,1);

	if(cam_target != NULL)
		VECTOR4D_COPY(&cam->target,cam_target);	//UVN目标位置
	else
		VECTOR4D_ZERO(&cam->target);

	cam->near_clip_z = near_clip_z;
	cam->far_clip_z = far_clip_z;

	cam->viewport_width = viewport_width;
	cam->viewport_height = viewport_height;

	cam->viewport_center_x = (viewport_width-1)/2;
	cam->viewport_center_y = (viewport_height-1)/2;

	//将所有的矩阵设置为单位矩阵
	MAT_IDENTITY_4X4(&cam->mcam);
	MAT_IDENTITY_4X4(&cam->mper);
	MAT_IDENTITY_4X4(&cam->mscr);

	//设置相关变量
	cam->fov = fov;

	//讲视平面大小设置为2X
	cam->viewplane_width = 2.0;
	cam->viewplane_height = 2.0/cam->aspect_ratio;

	//根据fov和视平面大小计算视距
	float tan_fov_div2 = tan(DEG_TO_RAD(fov/2));

	cam->view_dist = 0.5 * cam->viewport_width * tan_fov_div2;

	if(fov == 90.0){
		//建立剪裁面
		POINT3D pt_origin;	//裁剪面上的一个点
		VECTOR3D_INITXYZ(&pt_origin,0,0,0);

		VECTOR3D vn;	//面法线

		// 右裁剪面
		VECTOR3D_INITXYZ(&vn,1,0,-1);	//平面 x=z
		PLANE3D_Init(&cam->rt_clip_plane, &pt_origin, &vn, 1);
	}
	else
	{
		POINT3D pt_origin;	//平面上的一个点
		VECTOR3D_INITXYZ();		
	}
}