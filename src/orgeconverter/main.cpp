#include "main.h"

using namespace tinyxml2;
using namespace std;

#define cname(sign) str.clear();str.append(sign);str.append(file_no);
XMLDocument doc;
XMLDocument out;

int formatVert(XMLElement *vertex, string &str)
{
	int count = 0;
	str.clear();
	char textstr[128];
	while(vertex){
		count++;
		XMLElement *pos = vertex->FirstChildElement("position");
		float x = pos->FloatAttribute("x");
		float y = pos->FloatAttribute("y");
		float z = pos->FloatAttribute("z");
		sprintf(textstr, "%f %f %f ", x, y, z);
		vertex=vertex->NextSiblingElement();
		str.append(textstr);
	}
	return count;
}

int formatUV(XMLElement *vertex, string &str)
{
	int count = 0;
	str.clear();
	char textstr[128];
	while(vertex){
		count++;
		XMLElement *pos = vertex->FirstChildElement("texcoord");
		float u = pos->FloatAttribute("u");
		float v = pos->FloatAttribute("v");
		sprintf(textstr, "%f %f ", u, 1.0-v);
		vertex=vertex->NextSiblingElement();
		str.append(textstr);
	}
	return count;
}

int formatIndex(XMLElement *vertex, string &str)
{
	int count = 0;
	str.clear();
	char textstr[128];
	while(vertex){
		count++;
		int v1 = vertex->IntAttribute("v1");
		int v2 = vertex->IntAttribute("v2");
		int v3 = vertex->IntAttribute("v3");
		int uv1 = v1;
		int uv2 = v2;
		int uv3 = v3;
		sprintf(textstr, "%d %d %d %d %d %d ", v1, uv1, v2, uv2, v3, uv3);
		//sprintf(textstr, "%d %d %d ", v1, v2 ,v3);
		vertex=vertex->NextSiblingElement();
		str.append(textstr);
	}
	return count;
}

void formatVCount(int count, string &str)
{
	str.clear();
	while(count > 0){
		str.append("3 ");
		count-=1;
	}
}

XMLElement* buildVSource(char *file_no, XMLElement *surface)
{
	int count;
	string str;
	XMLElement *sourcenode = out.NewElement("source")->ToElement();
	cname("mesh-position");
	sourcenode->SetAttribute("id",str.c_str());
		XMLElement *floatarrnode = out.NewElement("float_array");
		count = formatVert(surface->FirstChildElement("geometry")->FirstChildElement("vertexbuffer")->FirstChildElement("vertex"), str);
		XMLText *xtext = out.NewText(str.c_str())->ToText();
		cname("mesh-position-array");
		floatarrnode->SetAttribute("id",str.c_str()); floatarrnode->SetAttribute("count",count*3);
		XMLElement *technode = out.NewElement("technique_common")->ToElement();
			XMLElement *accenode = out.NewElement("accessor")->ToElement();
			cname("#mesh-position-array");
			accenode->SetAttribute("source",str.c_str()); accenode->SetAttribute("count",count); accenode->SetAttribute("stride",3);
				XMLElement *p1node = out.NewElement("param")->ToElement();
				p1node->SetAttribute("name","X"); p1node->SetAttribute("type","float");
				XMLElement *p2node = out.NewElement("param")->ToElement();
				p2node->SetAttribute("name","Y"); p2node->SetAttribute("type","float");
				XMLElement *p3node = out.NewElement("param")->ToElement();
				p3node->SetAttribute("name","Z"); p3node->SetAttribute("type","float");

	accenode->InsertEndChild(p1node);
	accenode->InsertEndChild(p2node);
	accenode->InsertEndChild(p3node);
	technode->InsertEndChild(accenode);
		floatarrnode->InsertEndChild(xtext);
	sourcenode->InsertEndChild(floatarrnode);
	sourcenode->InsertEndChild(technode);
	return sourcenode;
}

XMLElement* buildUVSource(char *file_no, XMLElement *surface)
{
	int count;
	string str;
	XMLElement *sourcenode = out.NewElement("source")->ToElement();
	cname("mesh-uv");
	sourcenode->SetAttribute("id",str.c_str());
		XMLElement *floatarrnode = out.NewElement("float_array");
		count = formatUV(surface->FirstChildElement("geometry")->FirstChildElement("vertexbuffer")->FirstChildElement("vertex"), str);
		XMLText *xtext = out.NewText(str.c_str())->ToText();
		cname("mesh-uv-array");
		floatarrnode->SetAttribute("id",str.c_str()); floatarrnode->SetAttribute("count",count*2);
		XMLElement *technode = out.NewElement("technique_common")->ToElement();
			XMLElement *accenode = out.NewElement("accessor")->ToElement();
			cname("#mesh-uv-array");
			accenode->SetAttribute("source",str.c_str()); accenode->SetAttribute("count",count); accenode->SetAttribute("stride",2);
				XMLElement *p1node = out.NewElement("param")->ToElement();
				p1node->SetAttribute("name","S"); p1node->SetAttribute("type","float");
				XMLElement *p2node = out.NewElement("param")->ToElement();
				p2node->SetAttribute("name","T"); p2node->SetAttribute("type","float");

	accenode->InsertEndChild(p1node);
	accenode->InsertEndChild(p2node);
	technode->InsertEndChild(accenode);
		floatarrnode->InsertEndChild(xtext);
	sourcenode->InsertEndChild(floatarrnode);
	sourcenode->InsertEndChild(technode);
	return sourcenode;
}

int main(int argc, char * argv[]){
	//��ȡ��
	doc.LoadFile(argv[1]);
	XMLElement *scene=doc.RootElement();
	XMLElement *surface=scene->FirstChildElement("submeshes")->FirstChildElement("submesh");
	
	//������
	out.LoadFile("template.dae");
	XMLElement *outscene=out.RootElement();	
	XMLElement *geolib = outscene->FirstChildElement("library_geometries");
	XMLElement *sceneNode= outscene->FirstChildElement("library_visual_scenes");
	
	//����ÿ��submesh, ȡ������������
	int i=0;
	char file_no[4];
	int count;
	string str;
	while(surface){
		itoa(i, file_no, 10);
		cname("mesh");
		XMLElement *geonode = out.NewElement("geometry")->ToElement();
		geonode->SetAttribute("id",str.c_str()); geonode->SetAttribute("name","Cube");
		
		XMLElement *meshnode = out.NewElement("mesh")->ToElement();
		
		XMLElement *sourcenode = buildVSource(file_no,surface);
		XMLElement *uvSourcenode = buildUVSource(file_no,surface);
		
		XMLElement *vecnode = out.NewElement("vertices")->ToElement();
		cname("mesh-vertices");
		vecnode->SetAttribute("id",str.c_str());
			XMLElement *pinputnode = out.NewElement("input")->ToElement();
			cname("#mesh-position");
			pinputnode->SetAttribute("semantic","POSITION"); pinputnode->SetAttribute("source",str.c_str());

		vecnode->InsertEndChild(pinputnode);
		
		XMLElement *polynode = out.NewElement("triangles")->ToElement();
		polynode->SetAttribute("material","Material-material");
			XMLElement *vinputnode = out.NewElement("input")->ToElement();
			cname("#mesh-vertices");
			vinputnode->SetAttribute("semantic","VERTEX"); vinputnode->SetAttribute("source",str.c_str()); vinputnode->SetAttribute("offset","0");
			XMLElement *pnode = out.NewElement("p")->ToElement();
			count = formatIndex(surface->FirstChildElement("faces")->FirstChildElement("face"), str);
			XMLText *ptext = out.NewText(str.c_str())->ToText();
			XMLElement *uvnode = out.NewElement("input")->ToElement();
			cname("#mesh-uv");
			uvnode->SetAttribute("semantic","TEXCOORD"); uvnode->SetAttribute("source",str.c_str()); uvnode->SetAttribute("offset","1");uvnode->SetAttribute("set","0");
		polynode->SetAttribute("count",count);
		polynode->InsertEndChild(vinputnode);
		polynode->InsertEndChild(uvnode);
		polynode->InsertEndChild(pnode);
			pnode->InsertEndChild(ptext);

		meshnode->InsertEndChild(sourcenode);
		meshnode->InsertEndChild(uvSourcenode);
		meshnode->InsertEndChild(vecnode);
		meshnode->InsertEndChild(polynode);
		
		geonode->InsertEndChild(meshnode);
     	geolib->InsertEndChild(geonode);

		XMLElement *visualnode = out.NewElement("visual_scene")->ToElement();
     	XMLElement *nodenode = out.NewElement("node")->ToElement();
     	cname("cube");
     	nodenode->SetAttribute("id",str.c_str()); nodenode->SetAttribute("name",str.c_str()); nodenode->SetAttribute("type","NODE");
     		XMLElement *instancenode = out.NewElement("instance_geometry")->ToElement();
     		cname("#mesh");
     		instancenode->SetAttribute("url",str.c_str());
     	nodenode->InsertEndChild(instancenode);
     	visualnode->InsertEndChild(nodenode);
     	sceneNode->InsertEndChild(visualnode);
     	
     	surface=surface->NextSiblingElement();
     	i++;
	}
	str.clear();
	str.append(argv[1]);
	str.append(".dae");
	out.SaveFile(str.c_str());
	return 0;
}
