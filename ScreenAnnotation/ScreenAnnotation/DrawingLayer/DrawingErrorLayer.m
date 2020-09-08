//
//  DrawingErrorLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/20.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingErrorLayer.h"

@implementation DrawingErrorLayer

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    startPoint.x += 7.0;
    startPoint.y += 7.0;
    self.lineWidth = 1.0;
    self.fillColor = [[NSColor colorWithRed:243.0 / 255.0 green:86.0 / 255.0 blue:48.0 / 255.0 alpha:1.0] CGColor];
    self.strokeColor = [[NSColor colorWithRed:243.0 / 255.0 green:86.0 / 255.0 blue:48.0 / 255.0 alpha:1.0] CGColor];
    
    [super movePathWithStartPoint:startPoint];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 5.66, startPoint.y - 5.66)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x, startPoint.y - 11.32)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 2.12, startPoint.y - 13.44)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 7.73, startPoint.y - 7.78)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 13.44, startPoint.y - 13.44)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 15.56, startPoint.y - 11.32)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 9.9, startPoint.y - 5.66)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 15.56, startPoint.y)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 13.44, startPoint.y + 2.12 )];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 7.78, startPoint.y - 3.54)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x - 2.12, startPoint.y + 2.12)];
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
