//
//  DrawingCorrectLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/20.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingCorrectLayer.h"

@implementation DrawingCorrectLayer

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    startPoint.x += 6.0;
    startPoint.y += 8.0;
    self.lineWidth = 1.0;
    self.fillColor = [[NSColor colorWithRed:76.0 / 255.0 green:188.0 / 255.0 blue:60.0 / 255.0 alpha:1.0] CGColor];
    self.strokeColor = [[NSColor colorWithRed:76.0 / 255.0 green:188.0 / 255.0 blue:60.0 / 255.0 alpha:1.0] CGColor];
    
    [super movePathWithStartPoint:startPoint];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 2.16, startPoint.y - 2.16)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 9.66, startPoint.y - 13.84)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 15.84, startPoint.y - 7.7)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 13.73, startPoint.y - 5.6)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 9.67, startPoint.y - 9.66)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x, startPoint.y)];
    [bezierPath closePath];
    bezierPath.windingRule = NSEvenOddWindingRule;
    
    self.path = bezierPathToCGPath(bezierPath);
    self.bezierPath = bezierPath;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;

    [super movePathWithEndPoint:endPoint];
}

@end
