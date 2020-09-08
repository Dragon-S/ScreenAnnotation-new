//
//  DrawingQuestionMarkLayer.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/20.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingQuestionMarkLayer.h"

@implementation DrawingQuestionMarkLayer

- (void)movePathWithStartPoint:(CGPoint)startPoint {
    startPoint.y -= 2.0;
    self.lineWidth = 1.0;
    self.fillColor = [[NSColor colorWithRed:64.0 / 255.0 green:138.0 / 255.0 blue:198.0 / 255.0 alpha:1.0] CGColor];
    self.strokeColor = [[NSColor colorWithRed:64.0 / 255.0 green:138.0 / 255.0 blue:198.0 / 255.0 alpha:1.0] CGColor];

    [super movePathWithStartPoint:startPoint];
    
    NSBezierPath *bezierPaht = [NSBezierPath bezierPath];
    [bezierPaht moveToPoint:startPoint];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 1.18, startPoint.y - 0.51)
               controlPoint1:NSMakePoint(startPoint.x - 0.5, startPoint.y)
               controlPoint2:NSMakePoint(startPoint.x - 0.84, startPoint.y - 0.17)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 1.68, startPoint.y - 1.69)
               controlPoint1:NSMakePoint(startPoint.x - 1.51, startPoint.y - 0.84)
               controlPoint2:NSMakePoint(startPoint.x - 1.68, startPoint.y - 1.18)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 1.18, startPoint.y - 2.86)
               controlPoint1:NSMakePoint(startPoint.x - 1.68, startPoint.y - 2.19)
               controlPoint2:NSMakePoint(startPoint.x - 1.51, startPoint.y - 2.53)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x, startPoint.y - 3.37)
               controlPoint1:NSMakePoint(startPoint.x - 0.84, startPoint.y - 3.2)
               controlPoint2:NSMakePoint(startPoint.x - 0.5, startPoint.y - 3.37)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 1.18, startPoint.y - 2.86)
               controlPoint1:NSMakePoint(startPoint.x + 0.51, startPoint.y - 3.37)
               controlPoint2:NSMakePoint(startPoint.x + 0.84, startPoint.y - 3.2)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 1.69, startPoint.y - 1.69)
               controlPoint1:NSMakePoint(startPoint.x + 1.52, startPoint.y - 2.53)
               controlPoint2:NSMakePoint(startPoint.x + 1.69, startPoint.y - 2.19)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 1.18, startPoint.y - 0.51)
               controlPoint1:NSMakePoint(startPoint.x + 1.69, startPoint.y - 1.18)
               controlPoint2:NSMakePoint(startPoint.x + 1.52, startPoint.y - 0.84)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x, startPoint.y)
               controlPoint1:NSMakePoint(startPoint.x + 0.84, startPoint.y - 0.17)
               controlPoint2:NSMakePoint(startPoint.x + 0.51, startPoint.y)];
    [bezierPaht closePath];
    
    [bezierPaht moveToPoint:NSMakePoint(startPoint.x + 0.32, startPoint.y + 12.63)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 3.47, startPoint.y + 11.2)
               controlPoint1:NSMakePoint(startPoint.x - 1.62, startPoint.y + 12.63)
               controlPoint2:NSMakePoint(startPoint.x - 2.52, startPoint.y + 12.15)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 5.05, startPoint.y + 7.37)
               controlPoint1:NSMakePoint(startPoint.x - 4.58, startPoint.y + 10.24)
               controlPoint2:NSMakePoint(startPoint.x - 5.05, startPoint.y + 8.97)];
    [bezierPaht lineToPoint:NSMakePoint(startPoint.x - 3.13, startPoint.y + 7.37)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 2.05, startPoint.y + 9.6)
               controlPoint1:NSMakePoint(startPoint.x - 2.68, startPoint.y + 8.33)
               controlPoint2:NSMakePoint(startPoint.x - 2.52, startPoint.y + 8.97)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 0.16, startPoint.y + 10.56)
               controlPoint1:NSMakePoint(startPoint.x - 1.58, startPoint.y + 10.24)
               controlPoint2:NSMakePoint(startPoint.x - 0.94, startPoint.y + 10.56)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 2.06, startPoint.y + 9.92)
               controlPoint1:NSMakePoint(startPoint.x + 0.95, startPoint.y + 10.56)
               controlPoint2:NSMakePoint(startPoint.x + 1.58, startPoint.y + 10.4)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 2.69, startPoint.y + 8.17)
               controlPoint1:NSMakePoint(startPoint.x + 2.53, startPoint.y + 9.44)
               controlPoint2:NSMakePoint(startPoint.x + 2.69, startPoint.y + 8.81)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 2.06, startPoint.y + 6.58)
               controlPoint1:NSMakePoint(startPoint.x + 2.69, startPoint.y + 7.53)
               controlPoint2:NSMakePoint(startPoint.x + 2.53, startPoint.y + 7.05)];
    [bezierPaht lineToPoint: NSMakePoint(startPoint.x + 1.58, startPoint.y + 6.1)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 0.94, startPoint.y + 3.23)
               controlPoint1:NSMakePoint(startPoint.x + 0.32, startPoint.y + 4.82)
               controlPoint2:NSMakePoint(startPoint.x - 0.63, startPoint.y + 3.63)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x - 1.26, startPoint.y + 1.16)
               controlPoint1:NSMakePoint(startPoint.x - 1.26, startPoint.y + 2.75)
               controlPoint2:NSMakePoint(startPoint.x - 1.26, startPoint.y + 1.96)];
    [bezierPaht lineToPoint: NSMakePoint(startPoint.x - 1.26, startPoint.y + 0.84)];
    [bezierPaht lineToPoint: NSMakePoint(startPoint.x + 1.11, startPoint.y + 0.84)];
    [bezierPaht lineToPoint: NSMakePoint(startPoint.x + 1.11, startPoint.y + 1.16)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 1.42, startPoint.y + 2.59)
               controlPoint1:NSMakePoint(startPoint.x + 1.11, startPoint.y + 1.64)
               controlPoint2:NSMakePoint(startPoint.x + 1.27, startPoint.y + 2.12)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 2.37, startPoint.y + 3.71)
               controlPoint1:NSMakePoint(startPoint.x + 1.58, startPoint.y + 3.07)
               controlPoint2:NSMakePoint(startPoint.x + 1.9, startPoint.y + 2.39)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 4.27, startPoint.y + 5.46)
               controlPoint1:NSMakePoint(startPoint.x + 3.48, startPoint.y + 4.66)
               controlPoint2:NSMakePoint(startPoint.x + 4.11, startPoint.y + 5.14)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 5.06, startPoint.y + 8.17)
               controlPoint1:NSMakePoint(startPoint.x + 4.9, startPoint.y + 6.1)
               controlPoint2:NSMakePoint(startPoint.x + 5.06, startPoint.y + 7.05)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 3.79, startPoint.y + 11.36)
               controlPoint1:NSMakePoint(startPoint.x + 5.06, startPoint.y + 9.44)
               controlPoint2:NSMakePoint(startPoint.x + 4.58, startPoint.y + 10.56)];
    [bezierPaht curveToPoint:NSMakePoint(startPoint.x + 0.32, startPoint.y + 12.63)
               controlPoint1:NSMakePoint(startPoint.x + 2.84, startPoint.y + 12.31)
               controlPoint2:NSMakePoint(startPoint.x + 1.74, startPoint.y + 12.63)];
    [bezierPaht closePath];
    bezierPaht.windingRule = NSEvenOddWindingRule;
    
    self.path = bezierPathToCGPath(bezierPaht);
    self.bezierPath = bezierPaht;
}

- (void)movePathWithEndPoint:(CGPoint)endPoint {
    self.endPoint = endPoint;

    [super movePathWithEndPoint:endPoint];
}

@end
