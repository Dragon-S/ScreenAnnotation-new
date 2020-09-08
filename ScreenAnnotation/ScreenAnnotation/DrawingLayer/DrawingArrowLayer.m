//
//  DrawingArrowLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/16.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingArrowLayer.h"

@implementation DrawingArrowLayer

- (void)movePathWithMovePoint:(CGPoint)endPoint {
    self.endPoint = endPoint;

    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:self.startPoint];
    [bezierPath lineToPoint:endPoint];
    [bezierPath appendBezierPath:[self createArrowWithStartPoint:self.startPoint endPoint:endPoint]];
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;

    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:self.startPoint];
    [bezierPath lineToPoint:endPoint];
    [bezierPath appendBezierPath:[self createArrowWithStartPoint:self.startPoint endPoint:endPoint]];
    
    self.path = bezierPathToCGPath(bezierPath);
    
    self.bezierPath = bezierPath;
    [super movePathWithEndPoint:endPoint];
}

@end
