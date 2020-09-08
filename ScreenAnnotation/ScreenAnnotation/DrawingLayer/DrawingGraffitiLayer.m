//
//  DrawingGraffitiLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/16.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingGraffitiLayer.h"

@implementation DrawingGraffitiLayer

- (void)movePathWithMovePoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    self.startPoint = ((NSValue*)self.pointArray.lastObject).pointValue;

    NSBezierPath *bezierPath = self.bezierPath;
    [bezierPath moveToPoint:((NSValue*)self.pointArray.lastObject).pointValue];
    [bezierPath lineToPoint:endPoint];
    self.path = bezierPathToCGPath(bezierPath);
    
    [self.pointArray addObject:[NSValue valueWithPoint:endPoint]];
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    self.startPoint = ((NSValue*)self.pointArray.lastObject).pointValue;

    NSBezierPath *bezierPath = self.bezierPath;
    [bezierPath moveToPoint:((NSValue*)self.pointArray.lastObject).pointValue];
    [bezierPath lineToPoint:endPoint];
    self.path = bezierPathToCGPath(bezierPath);
    
    [self.pointArray addObject:[NSValue valueWithPoint:endPoint]];
    
    [super movePathWithEndPoint:endPoint];
}


@end
