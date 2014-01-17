#include "main.h"

using namespace tinyxml2;

XMLDocument doc;
XMLDocument out;
int main(){
	doc.LoadFile("tree05.xml");
	out.LoadFile("template.dae");
	XMLElement *scene=doc.RootElement();
	XMLElement *outscene=out.RootElement();	
	XMLElement *surface=scene->FirstChildElement("submeshes")->FirstChildElement("submesh");
	while (surface){
		surface=surface->NextSiblingElement();
		XMLNode *node = out.NewElement("foo");
     	outscene->FirstChildElement("library_geometries")->InsertEndChild(node);
	}
	out.SaveFile("tree05.dae");
	return 0;
}