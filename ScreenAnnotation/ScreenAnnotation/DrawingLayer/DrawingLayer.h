//
//  DrawingLayer.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "SATypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

CGPathRef bezierPathToCGPath(NSBezierPath *bezierPath);

@interface DrawingLayer : CAShapeLayer

@property (nonatomic, strong) NSMutableArray *pointArray;  //记录图形绘制点
@property (nonatomic, assign) CGPoint startPoint;          //起始坐标
@property (nonatomic, assign) CGPoint endPoint;            //终点坐标

@property (nonatomic, strong) NSBezierPath *bezierPath;

+ (instancetype)createDrawingLayerWith:(DrawingType)drawingType;

- (void)movePathWithStartPoint:(CGPoint)startPoint;
- (void)movePathWithMovePoint:(CGPoint)endPoint;
- (void)movePathWithEndPoint:(CGPoint)endPoint;

- (void)moveBy:(CGPoint)delta;
- (void)resizeBy:(NSRect)offsetRect;
- (void)selectPathWithPath:(NSBezierPath *)bezierPath;
- (void)selectPathWithRect:(NSRect)rect;

- (NSBezierPath *)createArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
