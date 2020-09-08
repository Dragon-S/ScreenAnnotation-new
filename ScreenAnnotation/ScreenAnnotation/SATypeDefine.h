//
//  SATypeDefine.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#ifndef SATypeDefine_h
#define SATypeDefine_h

typedef enum : NSUInteger {
    ToolTypeMouse = 0,
    ToolTypeSelect,
    ToolTypePen,
    ToolTypeText,
    ToolTypeShape,
    ToolTypeColor,
    ToolTypeErase,
    ToolTypeUndo,
    ToolTypeRedo,
    ToolTypeClear,
    ToolTypeSave,
} ToolType;

typedef enum : NSUInteger {
    DrawingTypeGraffiti = 0,        //涂鸦
    DrawingTypeArrow,               //单箭头
    DrawingTypeLine,                //直线
    DrawingTypeDottedline,          //虚线
    DrawingTypeRulerArrow,          //双箭头直线
    DrawingTypeRulerLine,           //双杠直线
    DrawingTypeOval,                //椭圆
    DrawingTypeCircle,              //圆形
    DrawingTypeRect,                //矩形
    DrawingTypeTriangle,            //三角形
    DrawingTypeArc,                 //圆弧
    DrawingTypeCosine,              //正余弦
    DrawingTypeTrapezoid,           //梯形
    DrawingTypeRhombus,             //菱形
    DrawingTypePentagon,            //五边形
    DrawingTypeHexagon,             //六边形
    DrawingTypeAxis,                //坐标系
    DrawingTypeRighTangle,          //直角坐标系
    DrawingTypeThreeDCoordinate,    //三维坐标系
    DrawingTypeSphere,              //球体
    DrawingTypeTriangularPyramid,   //三菱锥
    DrawingTypeCone,                //圆锥
    DrawingTypeCylinder,            //圆柱
    DrawingTypeCuboid,              //立方体
    DrawingTypeSelectBorder,
    DrawingTypeCorrectMark,
    DrawingTypeErrorMark,
    DrawingTypeHeartMark,
    DrawingTypeQuestionMark,
} DrawingType;


#endif /* SATypeDefine_h */
