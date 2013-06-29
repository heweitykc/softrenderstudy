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

void rotationM(float ax, float ay, float az, MATRIX4X4& matrix)
{
	float fSinPitch        = sin( ax * 0.5 );
	float fCosPitch        = cos( ax * 0.5 );
	float fSinYaw          = sin( ay * 0.5 );
	float fCosYaw          = cos( ay * 0.5 );
	float fSinRoll         = sin( az * 0.5 );
	float fCosRoll         = cos( az * 0.5 );
	float fCosPitchCosYaw  = fCosPitch * fCosYaw;
	float fSinPitchSinYaw  = fSinPitch * fSinYaw;

	float x = fSinRoll * fCosPitchCosYaw     - fCosRoll * fSinPitchSinYaw;
	float y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
	float z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
	float w = fCosRoll * fCosPitchCosYaw     + fSinRoll * fSinPitchSinYaw;
	
	float xx = x * x;
	float xy = x * y;
	float xz = x * z;
	float xw = x * w;
	float yy = y * y;
	float yz = y * z;
	float yw = y * w;
	float zz = z * z;
	float zw = z * w;
	
	matrix.M00 = 1 - 2 * ( yy + zz );
	matrix.M01 =     2 * ( xy - zw );
	matrix.M02 =     2 * ( xz + yw );
	
	matrix.M10 =     2 * ( xy + zw );
	matrix.M11 = 1 - 2 * ( xx + zz );
	matrix.M12 =     2 * ( yz - xw );
	
	matrix.M20 =     2 * ( xz - yw );
	matrix.M21 =     2 * ( yz + xw );
	matrix.M22 = 1 - 2 * ( xx + yy );
}

void RotateArbitraryLine(MATRIX4X4* pOut, VECTOR3D* v1, VECTOR3D* v2, float theta)
{
    float a = v1->x;
    float b = v1->y;
    float c = v1->z;

    VECTOR3D p;
	VECTOR3D_Sub(v2,v1,&p);
    VECTOR3D_Normalize(&p);
    float u = p.x;
    float v = p.y;
    float w = p.z;

    float uu = u * u;
    float uv = u * v;
    float uw = u * w;
    float vv = v * v;
    float vw = v * w;
    float ww = w * w;
    float au = a * u;
    float av = a * v;
    float aw = a * w;
    float bu = b * u;
    float bv = b * v;
    float bw = b * w;
    float cu = c * u;
    float cv = c * v;
    float cw = c * w;

    float costheta = cosf(theta);
    float sintheta = sinf(theta);

    pOut->M00 = uu + (vv + ww) * costheta;
    pOut->M01 = uv * (1 - costheta) + w * sintheta;
    pOut->M02 = uw * (1 - costheta) - v * sintheta;
    pOut->M03 = 0;

    pOut->M10 = uv * (1 - costheta) - w * sintheta;
    pOut->M11 = vv + (uu + ww) * costheta;
    pOut->M12 = vw * (1 - costheta) + u * sintheta;
    pOut->M13 = 0;

    pOut->M20 = uw * (1 - costheta) + v * sintheta;
    pOut->M21 = vw * (1 - costheta) - u * sintheta;
    pOut->M22 = ww + (uu + vv) * costheta;
    pOut->M23 = 0;

    pOut->M30 = (a * (vv + ww) - u * (bv + cw)) * (1 - costheta) + (bw - cv) * sintheta;
    pOut->M31 = (b * (uu + ww) - v * (au + cw)) * (1 - costheta) + (cu - aw) * sintheta;
    pOut->M32 = (c * (uu + vv) - w * (au + bv)) * (1 - costheta) + (av - bu) * sintheta;
    pOut->M33 = 1;
}