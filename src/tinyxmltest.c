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
	char str0[] = "#hello,world!";
	int len = strlen(str0)-1;
	char *str1 = (char*)malloc(len);
	memset(str1,0,len);
	strncpy(str1, str0+1, len);
	printf("len=%d,\nstr1=%s",len,str1);
	free(str1);
	return 0;
}