char pbuff[1024];

float XX(VECTOR3D& v)
{
	return ((v.x+1)/2)*400;	
}
float YY(VECTOR3D& v)
{
	return ((1-(v.y+1)/2))*400;
}

void p(char* str, int len)
{
    AS3_DeclareVar(myString, String);
    AS3_CopyCStringToVar(myString, str, len);
    AS3_Trace(myString);
}

//画点
void AS3DrawP(float x,float y,int c)
{
	//memset(pbuff,0,1024);
	//sprintf(pbuff,"x=%f,y=%f",x,y);
	//p(pbuff,strlen(pbuff));
	
	inline_as3(
		"CModule.activeConsole.bmd.setPixel32(%0, %1, %2);\n" 
		//"CModule.activeConsole.bmd.setPixel32(%0, %1+1, %2);\n" 
		//"CModule.activeConsole.bmd.setPixel32(%0+1, %1, %2);\n" 
		//"CModule.activeConsole.bmd.setPixel32(%0+1, %1+1, %2);\n" 
		: :"r"(int(x)), "r"(int(y)), "r"(c)
	);
}

//画线
void AS3DrawL(VECTOR3D& v1,VECTOR3D& v2,int c)
{
float x1, y1, x2, y2;

	memset(pbuff,0,1024);
	sprintf(pbuff,"(%f,%f,%f) - (%f,%f,%f)",v1.x,v1.y,v1.z,v2.x,v2.y,v2.z);
	p(pbuff,strlen(pbuff));
	
x1 = XX(v1);
y1 = YY(v1);
x2 = XX(v2);
y2 = YY(v2);
float k,dx,dy,x,y,xend,yend;
dx = x2 - x1;
dy = y2 - y1;
if(fabs(dx) >= fabs(dy))
{
k = dy / dx;
if(dx > 0)
{
x = x1;
y = y1;
xend = x2;
}
else
{
x = x2;
y = y2;
xend = x1;
}
while(x <= xend)
{
AS3DrawP(x, y, c);
y = y + k;
x = x + 1;
}
}
else
{
k = dx / dy;
if(dy > 0)
{
x = x1;
y = y1;
yend = y2;
}
else
{
x = x2;
y = y2;
yend = y1;
}
while(y <= yend)
{
AS3DrawP(x, y, c);
x = x + k;
y = y + 1;
}
}
}