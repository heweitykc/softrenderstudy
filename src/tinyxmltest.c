#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "xml/tinyxml2.h"

using namespace tinyxml2;

int main(){
	XMLDocument doc;
	doc.LoadFile("res/1.dae");
	tinyxml2::XMLElement *element = doc.FirstChildElement("COLLADA")->FirstChildElement("library_geometries")->FirstChildElement("geometry");
	while(element){
		printf("txt=%s\n",element->Attribute("id"));
		element = element->NextSiblingElement("geometry");
	}

	return 0;
}