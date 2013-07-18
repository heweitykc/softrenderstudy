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
				obj1->vlist_local[i/3].M[i%3] = atoi(pch);
				
				pch = strtok(NULL," ");
				i++;
			}
			obj1->num_vertices = i/3;			
			
			inputElement = geometryElement->FirstChildElement("mesh")->FirstChildElement("polylist")->FirstChildElement("p");
			const char* tempchr3 = inputElement->GetText();
			pch = strtok((char*)tempchr3, " ");
			i=0;
			while(pch != NULL){
				if(i%2 == 0)
				{
					//obj1->plist[i/6].vlist = obj1->vlist_local;
					int value = atoi(pch);
					obj1->plist[i/6].vert[(i%6)/2] = value;
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
