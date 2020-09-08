//
//  DrawingRectLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/16.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingRectLayer.h"

@implementation DrawingRectLayer

- (void)movePathWithMovePoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    
    CGRect rectToFill = CGRectMake(self.startPoint.x, self.startPoint.y, endPoint.x - self.startPoint.x, endPoint.y - self.startPoint.y);
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRect:rectToFill];
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;
    
    CGRect rectToFill = CGRectMake(self.startPoint.x, self.startPoint.y, endPoint.x - self.startPoint.x, endPoint.y - self.startPoint.y);
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRect:rectToFill];
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
    
    [super movePathWithEndPoint:endPoint];
}

@end
