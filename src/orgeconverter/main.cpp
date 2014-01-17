#include "main.h"

using namespace tinyxml2;

XMLDocument doc;
XMLDocument out;
int main(){
	doc.LoadFile("tree05.xml");
	out.LoadFile("template.dae");
	XMLElement *scene=doc.RootElement();
	XMLElement *surface=scene->FirstChildElement("submeshes")->FirstChildElement("submesh");
	while (surface){
		printf("%s\n", surface->FirstAttribute()->Name());
		surface=surface->NextSiblingElement();
	}
	return 0;
}