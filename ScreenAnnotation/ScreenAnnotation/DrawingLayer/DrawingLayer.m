//
//  DrawingLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingLayer.h"
#import "DrawingGraffitiLayer.h"
#import "DrawingRectLayer.h"
#import "DrawingOvalLayer.h"
#import "DrawingRhombusLayer.h"
#import "DrawingArrowLayer.h"
#import "DrawingLineLayer.h"
#import "DrawingCorrectLayer.h"
#import "DrawingErrorLayer.h"
#import "DrawingHeartLayer.h"
#import "DrawingQuestionMarkLayer.h"

static void CGPathCallback(void *info, const CGPathElement *element) {
    NSBezierPath *bezierPath = (__bridge NSBezierPath *)info;
    CGPoint *points = element->points;
    switch(element->type) {
        case kCGPathElementMoveToPoint: [bezierPath moveToPoint:points[0]]; break;
        case kCGPathElementAddLineToPoint: [bezierPath lineToPoint:points[0]]; break;
        case kCGPathElementAddQuadCurveToPoint: {
            NSPoint qp0 = bezierPath.currentPoint, qp1 = points[0], qp2 = points[1], cp1, cp2;
            CGFloat m = (2.0 / 3.0);
            cp1.x = (qp0.x + ((qp1.x - qp0.x) * m));
            cp1.y = (qp0.y + ((qp1.y - qp0.y) * m));
            cp2.x = (qp2.x + ((qp1.x - qp2.x) * m));
            cp2.y = (qp2.y + ((qp1.y - qp2.y) * m));
            [bezierPath curveToPoint:qp2 controlPoint1:cp1 controlPoint2:cp2];
            break;
        }
        case kCGPathElementAddCurveToPoint: [bezierPath curveToPoint:points[2] controlPoint1:points[0] controlPoint2:points[1]]; break;
        case kCGPathElementCloseSubpath: [bezierPath closePath]; break;
    }
}

static NSBezierPath* bezierPathWithCGPath(CGPathRef cgPath) {
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    CGPathApply(cgPath, (__bridge void *)bezierPath, CGPathCallback);
    return bezierPath;
}

CGPathRef bezierPathToCGPath(NSBezierPath *bezierPath) {
    CGMutablePathRef cgPath = CGPathCreateMutable();
    NSInteger count = [bezierPath elementCount];
    
    for (NSInteger i = 0; i < count; i++) {
        NSPoint points[3] = {0};
        
        switch ([bezierPath elementAtIndex:i associatedPoints:points]) {
            case NSMoveToBezierPathElement: {
                CGPathMoveToPoint(cgPath, NULL, points[0].x, points[0].y);
                break;
            }
            case NSLineToBezierPathElement: {
                CGPathAddLineToPoint(cgPath, NULL, points[0].x, points[0].y);
                break;
            }
            case NSCurveToBezierPathElement: {
                CGPathAddCurveToPoint(cgPath, NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                break;
            }
            case NSClosePathBezierPathElement: {
                CGPathCloseSubpath(cgPath);
                break;
            }
            default:
                break;;
        }
    }
    
    return cgPath;
}

static NSBezierPath* clickTargetPathForPath(NSBezierPath *path) {
    if (path == nil) {
        return nil;
    }
    
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(bezierPathToCGPath(path), NULL, fmaxf(35.0f, path.lineWidth), (CGLineCap)path.lineCapStyle, (CGLineJoin)path.lineJoinStyle, path.miterLimit);
    
    if (tapTargetPath == NULL) {
        return nil;
    }
    
    NSBezierPath *tapTarget = bezierPathWithCGPath(tapTargetPath);
    CGPathRelease(tapTargetPath);
    return tapTarget;
}

@interface DrawingLayer ()

@property (nonatomic, strong) NSBezierPath *clickBezierPath;

@end

@implementation DrawingLayer

+ (instancetype)createDrawingLayerWith:(DrawingType)drawingType {
    DrawingLayer *layer = nil;
    switch (drawingType) {
        case DrawingTypeGraffiti: {
            layer = [[DrawingGraffitiLayer alloc] init];
            break;
        }
        case DrawingTypeArrow: {
            layer = [[DrawingArrowLayer alloc] init];
            break;
        }
        case DrawingTypeLine: {
            layer = [[DrawingLineLayer alloc] init];
            break;
        }
//        case ZHFigureDrawingTypeLine:
//            layer = [[ZHDrawingLineLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeDottedline:
//            layer = [[ZHDrawingDottedlineLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeRulerArrow:
//            layer = [[ZHDrawingRulerArrowLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeRulerLine:
//            layer = [[ZHDrawingRulerLineLayer alloc] init];
//            break;
        case DrawingTypeOval: {
            layer = [[DrawingOvalLayer alloc] init];
            break;;
        }
//        case ZHFigureDrawingTypeCircle:
//            layer = [[ZHDrawingCircleLayer alloc] init];
//            break;
        case DrawingTypeRect: {
            layer = [[DrawingRectLayer alloc] init];
            break;
        }
//        case ZHFigureDrawingTypeTriangle:
//            layer = [[ZHDrawingTriangleLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeArc:
//            layer = [[ZHDrawingArcLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeCosine:
//            layer = [[ZHDrawingCosineLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeTrapezoid:
//            layer = [[ZHDrawingTrapezoidLayer alloc] init];
//            break;
        case DrawingTypeRhombus: {
            layer = [[DrawingRhombusLayer alloc] init];
            break;
        }
//        case ZHFigureDrawingTypePentagon://五边形
//            layer = [[ZHDrawingPentagonLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeHexagon://六边形
//            layer = [[ZHDrawingHexagonLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeAxis:
//            layer = [[ZHDrawingAxisLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeRighTangle:
//            layer = [[ZHDrawingRighTangleLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeThreeDCoordinate:
//            layer = [[ZHDrawingThreeDCoordinateLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeSphere:
//            layer = [[ZHDrawingSphereLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeTriangularPyramid:
//            layer = [[ZHDrawingTriangularPyramidLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeCone:
//            layer = [[ZHDrawingConeLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeCylinder:
//            layer = [[ZHDrawingCylinderLayer alloc] init];
//            break;
//        case ZHFigureDrawingTypeCuboid:
//            layer = [[ZHDrawingCuboidLayer alloc] init];
//            break;
        case DrawingTypeCorrectMark: {
            layer = [[DrawingCorrectLayer alloc] init];
            break;
        }
        case DrawingTypeErrorMark: {
            layer = [[DrawingErrorLayer alloc] init];
            break;
        }
        case DrawingTypeHeartMark: {
            layer = [[DrawingHeartLayer alloc] init];
            break;
        }
        case DrawingTypeQuestionMark: {
            layer = [[DrawingQuestionMarkLayer alloc] init];
            break;
        }
        default:
            break;
    }
    
    return layer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        self.strokeColor = [NSColor blackColor].CGColor;
        self.fillColor = [NSColor clearColor].CGColor;
        self.lineWidth = 4;
        self.pointArray = [NSMutableArray array];
        
        _pointArray = [NSMutableArray array];
        _bezierPath = [NSBezierPath bezierPath];
    }
    
    return self;
}

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    [_pointArray addObject:[NSValue valueWithPoint:startPoint]];
}

- (void)movePathWithMovePoint:(CGPoint)endPoint {
    
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {    
    _clickBezierPath = clickTargetPathForPath(_bezierPath);
}

- (BOOL)containsPoint:(CGPoint)point {
    return [_clickBezierPath containsPoint:point];
}

- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat xDist = (endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (NSBezierPath *)createArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat distance = [self distanceBetweenStartPoint:startPoint endPoint:endPoint];
    CGFloat distanceX = 8.0 * (ABS(endPoint.x - startPoint.x) / distance);
    CGFloat distanceY = 8.0 * (ABS(endPoint.y - startPoint.y) / distance);
    CGFloat distX = 4.0 * (ABS(endPoint.y - startPoint.y) / distance);
    CGFloat distY = 4.0 * (ABS(endPoint.x - startPoint.x) / distance);
    if (endPoint.x >= startPoint.x) {
        if (endPoint.y >= startPoint.y) {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        } else {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
    } else {
        if (endPoint.y >= startPoint.y) {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        } else {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
    }
    NSBezierPath *arrowPath = [NSBezierPath bezierPath];
    [arrowPath moveToPoint:endPoint];
    [arrowPath lineToPoint:pointDown];
    [arrowPath lineToPoint:pointUp];
    [arrowPath lineToPoint:endPoint];
    
    return arrowPath;
}

- (void)moveBy:(CGPoint)delta {
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:delta.x yBy:delta.y];
    [self.bezierPath transformUsingAffineTransform:transform];
    [self.clickBezierPath transformUsingAffineTransform:transform];
    
    self.path = bezierPathToCGPath(self.bezierPath);
}

- (void)resizeBy:(NSRect)offsetRect {
    NSAffineTransform *transform = [NSAffineTransform transform];
    //缩放
    [transform translateXBy:self.bezierPath.bounds.origin.x yBy:self.bezierPath.bounds.origin.y];
    CGFloat offscaleW = offsetRect.size.width / self.bezierPath.bounds.size.width;
    CGFloat offscaleH = offsetRect.size.height / self.bezierPath.bounds.size.height;
    [transform scaleXBy:1.0 + offscaleW yBy:1.0 + offscaleH];
    [transform translateXBy:-self.bezierPath.bounds.origin.x yBy:-self.bezierPath.bounds.origin.y];
    
    //平移
    [transform translateXBy:offsetRect.origin.x yBy:offsetRect.origin.y];
    
    [self.bezierPath transformUsingAffineTransform:transform];
    [self.clickBezierPath transformUsingAffineTransform:transform];
    
    self.path = bezierPathToCGPath(self.bezierPath);
}

- (void)selectPathWithPath:(NSBezierPath *)bezierPath {
    
}

- (void)selectPathWithRect:(NSRect)rect {
    
}

@end
