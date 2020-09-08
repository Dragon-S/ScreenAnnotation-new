//
//  DrawingHeartLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/20.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingHeartLayer.h"

@implementation DrawingHeartLayer

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    startPoint.x -= 8.0;
    startPoint.y -= 1.0;
    self.lineWidth = 1.0;
    self.fillColor = [[NSColor colorWithRed:253.0 / 255.0 green:23.0 / 255.0 blue:29.0 / 255.0 alpha:1.0] CGColor];
    self.strokeColor = [[NSColor colorWithRed:253.0 / 255.0 green:23.0 / 255.0 blue:29.0 / 255.0 alpha:1.0] CGColor];

    [super movePathWithStartPoint:startPoint];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 6.67, startPoint.y - 5.6)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 13.52, startPoint.y)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 14.01, startPoint.y + 0.55)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x + 14.01, startPoint.y + 7.88)
               controlPoint1:NSMakePoint(startPoint.x + 15.77, startPoint.y + 2.57)
               controlPoint2:NSMakePoint(startPoint.x + 15.77, startPoint.y + 5.86)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x + 10.81, startPoint.y + 9.4)
               controlPoint1:NSMakePoint(startPoint.x + 13.16, startPoint.y + 8.86)
               controlPoint2:NSMakePoint(startPoint.x + 12.02, startPoint.y + 9.4)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x + 7.61, startPoint.y + 7.88)
               controlPoint1:NSMakePoint(startPoint.x + 9.6, startPoint.y + 9.4)
               controlPoint2:NSMakePoint(startPoint.x + 8.47, startPoint.y + 8.86)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 7.11, startPoint.y + 7.31)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x + 6.41, startPoint.y + 7.31)
               controlPoint1:NSMakePoint(startPoint.x + 6.92, startPoint.y + 7.09)
               controlPoint2:NSMakePoint(startPoint.x + 6.61, startPoint.y + 7.09)];
    [bezierPath lineToPoint:NSMakePoint(startPoint.x + 5.91, startPoint.y + 7.88)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x + 2.71, startPoint.y + 9.4)
               controlPoint1:NSMakePoint(startPoint.x + 5.06, startPoint.y + 8.86)
               controlPoint2:NSMakePoint(startPoint.x + 3.92, startPoint.y + 9.4)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x - 0.49, startPoint.y + 7.88)
               controlPoint1:NSMakePoint(startPoint.x + 1.5, startPoint.y + 9.4)
               controlPoint2:NSMakePoint(startPoint.x + 0.37, startPoint.y + 8.86)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x - 1.81, startPoint.y + 4.22)
               controlPoint1:NSMakePoint(startPoint.x - 1.34, startPoint.y + 6.9)
               controlPoint2:NSMakePoint(startPoint.x - 1.81, startPoint.y + 5.6)];
    [bezierPath curveToPoint:NSMakePoint(startPoint.x - 0.49, startPoint.y + 0.55)
               controlPoint1:NSMakePoint(startPoint.x - 1.81, startPoint.y + 2.83)
               controlPoint2:NSMakePoint(startPoint.x - 1.34, startPoint.y + 1.53)];
    [bezierPath moveToPoint:startPoint];
    
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
