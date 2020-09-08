//
//  DrawingRhombusLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/16.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingRhombusLayer.h"

@implementation DrawingRhombusLayer

- (void)movePathWithMovePoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    
    CGFloat midX = self.startPoint.x + (endPoint.x - self.startPoint.x)/2;
    CGFloat midY = self.startPoint.y + (endPoint.y - self.startPoint.y)/2;
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(midX, self.startPoint.y)];
    [bezierPath lineToPoint:CGPointMake(self.startPoint.x, midY)];
    [bezierPath lineToPoint:CGPointMake(midX, endPoint.y)];
    [bezierPath lineToPoint:CGPointMake(endPoint.x, midY)];
    [bezierPath lineToPoint:CGPointMake(midX, self.startPoint.y)];
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    
    CGFloat midX = self.startPoint.x + (endPoint.x - self.startPoint.x)/2;
    CGFloat midY = self.startPoint.y + (endPoint.y - self.startPoint.y)/2;
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(midX, self.startPoint.y)];
    [bezierPath lineToPoint:CGPointMake(self.startPoint.x, midY)];
    [bezierPath lineToPoint:CGPointMake(midX, endPoint.y)];
    [bezierPath lineToPoint:CGPointMake(endPoint.x, midY)];
    [bezierPath lineToPoint:CGPointMake(midX, self.startPoint.y)];
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
    
    [super movePathWithEndPoint:endPoint];
}

@end
