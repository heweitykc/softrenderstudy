#ifndef DRAWUTILS_H
#define DRAWUTILS_H

#include "main.h"

float XX(VECTOR3D& v);
float YY(VECTOR3D& v);

void p(const char* str);

void fillTriangle(VECTOR3D& v3,POINT4D& p);

//画点
void AS3DrawP(float x,float y,int c);

//画线
void AS3DrawL(VECTOR3D& v1,VECTOR3D& v2,int c);

void rotationM(float ax, float ay, float az, MATRIX4X4& matrix);

void RotateArbitraryLine(MATRIX4X4* pOut, VECTOR3D* v1, VECTOR3D* v2, float theta);
void RotateArbitraryLine(MATRIX4X4* pOut, VECTOR3D* v1, VECTOR3D* v2, float theta);

#endif