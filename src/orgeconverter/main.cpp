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

int formatIndex(XMLElement *vertex, string &str)
{
	int count = 0;
	str.clear();
	char textstr[128];
	while(vertex){
		count++;
		int x = vertex->IntAttribute("v1");
		int y = vertex->IntAttribute("v2");
		int z = vertex->IntAttribute("v3");
		sprintf(textstr, "%d %d %d ", x, y, z);
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

int main(int argc, char * argv[]){
	//读取的
	doc.LoadFile(argv[1]);
	XMLElement *scene=doc.RootElement();
	XMLElement *surface=scene->FirstChildElement("submeshes")->FirstChildElement("submesh");
	
	//导出的
	out.LoadFile("template.dae");
	XMLElement *outscene=out.RootElement();	
	XMLElement *geolib = outscene->FirstChildElement("library_geometries");
	XMLElement *sceneNode= outscene->FirstChildElement("library_visual_scenes");
	
	//遍历每个submesh, 取出顶点和索引
	int i=0;
	char file_no[4];
	int count;
	string str;
	while(surface){
		itoa(i, file_no, 10);
		cname("mesh");
		XMLElement *geonode = out.NewElement("geometry")->ToElement();
		geonode->SetAttribute("id",str.c_str()); geonode->SetAttribute("name","Cube");
		cname("mesh-position");
		XMLElement *meshnode = out.NewElement("mesh")->ToElement();
		XMLElement *sourcenode = out.NewElement("source")->ToElement();
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
		
		XMLElement *vecnode = out.NewElement("vertices")->ToElement();
		cname("mesh-vertices");
		vecnode->SetAttribute("id",str.c_str());
			XMLElement *pinputnode = out.NewElement("input")->ToElement();
			cname("#mesh-position");
			pinputnode->SetAttribute("semantic","POSITION"); pinputnode->SetAttribute("source",str.c_str());

		vecnode->InsertEndChild(pinputnode);
		
		XMLElement *polynode = out.NewElement("polylist")->ToElement();
		polynode->SetAttribute("material","Material-material");
			XMLElement *vinputnode = out.NewElement("input")->ToElement();
			cname("#mesh-vertices");
			vinputnode->SetAttribute("semantic","VERTEX"); vinputnode->SetAttribute("source",str.c_str()); vinputnode->SetAttribute("offset","0");
			XMLElement *pnode = out.NewElement("p")->ToElement();
			count = formatIndex(surface->FirstChildElement("faces")->FirstChildElement("face"), str);
			XMLText *ptext = out.NewText(str.c_str())->ToText();
			XMLElement *vcountnode = out.NewElement("vcount")->ToElement();
			formatVCount(count, str);
			XMLText *vtext = out.NewText(str.c_str())->ToText();
		polynode->SetAttribute("count",count);
		polynode->InsertEndChild(vinputnode);
		polynode->InsertEndChild(vcountnode);
			vcountnode->InsertEndChild(vtext);
		polynode->InsertEndChild(pnode);
			pnode->InsertEndChild(ptext);

		meshnode->InsertEndChild(sourcenode);
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

/*
<geometry id="Cube-mesh" name="Cube">
  <mesh>
    <source id="Cube-mesh-positions">
      <float_array id="Cube-mesh-positions-array" count="24"></float_array>
      <technique_common>
        <accessor source="#Cube-mesh-positions-array" count="8" stride="3">
          <param name="X" type="float"/>
          <param name="Y" type="float"/>
          <param name="Z" type="float"/>
        </accessor>
      </technique_common>
    </source>
    <vertices id="Cube-mesh-vertices">
      <input semantic="POSITION" source="#Cube-mesh-positions"/>
    </vertices>
    <polylist material="Material-material" count="6">
      <input semantic="VERTEX" source="#Cube-mesh-vertices" offset="0"/>
      <vcount>4 4 4 4 4 4 </vcount>
      <p>0 0 1 0 2 0 3 0 4 1 7 1 6 1 5 1 0 2 4 2 5 2 1 2 1 3 5 3 6 3 2 3 2 4 6 4 7 4 3 4 4 5 0 5 3 5 7 5</p>
    </polylist>
  </mesh>
</geometry>
*/