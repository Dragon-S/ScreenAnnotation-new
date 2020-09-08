//
//  SelectBorderView.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/19.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "SelectBorderView.h"
#import <Quartz/Quartz.h>

const CGFloat kLINEWIDTH = 1.0;
const CGFloat kRADIUS = 5.0;

typedef NS_ENUM(NSInteger, SelectBorderAreaEdgeType) {
    SelectBorderAreaEdgeTypeNone,
    SelectBorderAreaEdgeTypeRight,
    SelectBorderAreaEdgeTypeLeft,
    SelectBorderAreaEdgeTypeUp,
    SelectBorderAreaEdgeTypeDown,
    SelectBorderAreaEdgeTypeRightUp,
    SelectBorderAreaEdgeTypeRightDown,
    SelectBorderAreaEdgeTypeLeftUp,
    SelectBorderAreaEdgeTypeLeftDown,
};

@interface SelectBorderView ()

@property (nonatomic, assign) NSPoint firstPoint;
@property (nonatomic, assign) NSPoint startPoint;
@property (nonatomic, retain) NSTrackingArea *vvtTrackingArea;
@property (nonatomic, assign) SelectBorderAreaEdgeType currentEdgeType;
@property (nonatomic, retain) NSCursor *resizeRightUpAndLeftDownCursor;
@property (nonatomic, retain) NSCursor *resizeRightDownAndLeftUpCursor;
@property (nonatomic, retain) NSCursor *dragCursor;

@end

@implementation SelectBorderView

- (instancetype)initWithFrame:(NSRect)frameRect {
    CGFloat x = frameRect.origin.x - kRADIUS;
    CGFloat y = frameRect.origin.y - kRADIUS;
    CGFloat width = frameRect.size.width + 2 * kRADIUS;
    CGFloat heigth = frameRect.size.height + 2 * kRADIUS;
    NSRect newRect = NSMakeRect(x, y, width, heigth);
    
    self = [super initWithFrame:newRect];
    if (self) {
        _currentEdgeType = SelectBorderAreaEdgeTypeNone;
        NSImage *dragCursorImage = [NSImage imageNamed:@"mouse-move"];
        NSImage *leftDownAndRightUpCursor = [NSImage imageNamed:@"leftDownAndRightUpCursor"];
        NSImage *leftUpAndRightDownCursor = [NSImage imageNamed:@"leftUpAndRightDownCursor"];
        _resizeRightDownAndLeftUpCursor = [[NSCursor alloc]
                                           initWithImage:leftUpAndRightDownCursor
                                           hotSpot:NSMakePoint(leftUpAndRightDownCursor.size.width / 2, leftUpAndRightDownCursor.size.height / 2)];
        _resizeRightUpAndLeftDownCursor = [[NSCursor alloc]
                                           initWithImage:leftDownAndRightUpCursor
                                           hotSpot:NSMakePoint(leftDownAndRightUpCursor.size.width / 2, leftDownAndRightUpCursor.size.height / 2)];
        _dragCursor = [[NSCursor alloc] initWithImage:dragCursorImage hotSpot:NSMakePoint(dragCursorImage.size.width / 2, dragCursorImage.size.height / 2)];
        
        [self vvtAddTrackingArea];
    }
    
    return self;
}

- (void)drawSmallCircle:(CGContextRef)contentRef WhitPoint:(NSPoint)point {
    CGContextSetStrokeColorWithColor(contentRef, [NSColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0].CGColor);
    CGContextAddArc(contentRef, point.x, point.y, kRADIUS, 0, 2 * M_PI, 0);
    CGContextStrokePath(contentRef);
    CGContextAddArc(contentRef, point.x, point.y, kRADIUS, 0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(contentRef, [NSColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor);
    CGContextFillPath(contentRef);
}

- (void)drawRect:(NSRect)dirtyRect {
    CGRect rectangle = NSMakeRect(kRADIUS, kRADIUS, [self frame].size.width - 2 * kRADIUS, [self frame].size.height - 2 * kRADIUS);
    [[NSColor clearColor] setFill];
    NSRectFill(rectangle);

    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    CGContextSetLineWidth(context, 1.0);

    //绘制黑色虚线
    CGFloat lengths[] = {10,10};
    CGContextSetStrokeColorWithColor(context, [NSColor blackColor].CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);

    //绘制白色虚线
    CGContextSetStrokeColorWithColor(context, [NSColor whiteColor].CGColor);
    CGContextSetLineDash(context, 10, lengths, 2);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);

    //绘制六个小圆形
    //左下
    [self drawSmallCircle:context WhitPoint:rectangle.origin];
    //左中
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x, rectangle.origin.y + rectangle.size.height / 2)];
    //左上
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x, rectangle.origin.y + rectangle.size.height)];
    //右下
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x + rectangle.size.width, rectangle.origin.y)];
    //右中
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x + rectangle.size.width, rectangle.origin.y + rectangle.size.height / 2)];
    //右上
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x + rectangle.size.width, rectangle.origin.y + rectangle.size.height)];
    //上中
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x + rectangle.size.width / 2, rectangle.origin.y + rectangle.size.height)];
    //下中
    [self drawSmallCircle:context WhitPoint:NSMakePoint(rectangle.origin.x + rectangle.size.width / 2, rectangle.origin.y)];
}

- (void)vvtRemoveTrackingArea {
    if (_vvtTrackingArea) {
        [self removeTrackingArea:_vvtTrackingArea];
        _vvtTrackingArea = nil;
    }
}

- (void)vvtAddTrackingArea {
    [self vvtRemoveTrackingArea];
    
    NSTrackingAreaOptions trackingOptions =
    NSTrackingCursorUpdate | NSTrackingEnabledDuringMouseDrag | NSTrackingMouseEnteredAndExited |
    NSTrackingActiveInActiveApp | NSTrackingMouseMoved;
    // note: NSTrackingActiveAlways flags turns off the cursor updating feature
    
    _vvtTrackingArea = [[NSTrackingArea alloc]
                      initWithRect: [self bounds] // in our case track the entire view
                      options: trackingOptions
                      owner: self
                      userInfo: nil];
    [self addTrackingArea: _vvtTrackingArea];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSColor *color = [[self window] backgroundColor];
    NSPoint curPoint = [self.superview convertPoint:[theEvent locationInWindow] toView:nil];
    _startPoint = curPoint;
    _firstPoint = curPoint;

    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setBackgroundColor:color];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSColor *color = [[self window] backgroundColor];
    NSPoint curPoint = [self.superview convertPoint:[theEvent locationInWindow] toView:nil];
    CGFloat dertX = curPoint.x - _startPoint.x;
    CGFloat dertY = curPoint.y - _startPoint.y;
    NSRect newFrame = self.frame;
    
    switch (_currentEdgeType) {
        case SelectBorderAreaEdgeTypeRight: {
            newFrame.size.width = newFrame.size.width + dertX;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(0.0, 0.0, dertX, 0.0)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeft: {
            newFrame.origin.x = newFrame.origin.x + dertX;
            newFrame.size.width = newFrame.size.width - dertX;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(dertX, 0.0, -dertX, 0.0)];
            break;
        }
        case SelectBorderAreaEdgeTypeUp: {
            newFrame.size.height = newFrame.size.height + dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(0.0, 0.0, 0.0, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeDown: {
            newFrame.origin.y = newFrame.origin.y + dertY;
            newFrame.size.height = newFrame.size.height - dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(0.0, dertY, 0.0, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeRightUp: {
            newFrame.size.width = newFrame.size.width + dertX;
            newFrame.size.height = newFrame.size.height + dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(0.0, 0.0, dertX, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeRightDown: {
            newFrame.origin.y = newFrame.origin.y + dertY;
            newFrame.size.width = newFrame.size.width + dertX;
            newFrame.size.height = newFrame.size.height - dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(0.0, dertY, dertX, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftUp: {
            newFrame.origin.x = newFrame.origin.x + dertX;
            newFrame.size.width = newFrame.size.width - dertX;
            newFrame.size.height = newFrame.size.height + dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(dertX, 0.0, -dertX, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftDown: {
            newFrame.origin.x = newFrame.origin.x + dertX;
            newFrame.origin.y = newFrame.origin.y + dertY;
            newFrame.size.width = newFrame.size.width - dertX;
            newFrame.size.height = newFrame.size.height - dertY;
            [_saDelegate resizeWithOffsetRect:NSMakeRect(dertX, dertY, -dertX, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeNone:
        default: {
            newFrame.origin.x = newFrame.origin.x + dertX;
            newFrame.origin.y = newFrame.origin.y + dertY;
            [_saDelegate moveWithOffsetPoint:NSMakePoint(dertX, dertY)];
            break;
        }
    }
    
    [self setFrame:newFrame];
    [self setNeedsDisplay:YES];
    [self vvtAddTrackingArea];
    _startPoint = curPoint;
    
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setBackgroundColor:color];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    CGRect rectangle = NSMakeRect(kRADIUS, kRADIUS, [self frame].size.width - 2 * kRADIUS, [self frame].size.height - 2 * kRADIUS);
    NSPoint curPoint = [[[self window] contentView] convertPoint:[theEvent locationInWindow] toView:self];
    NSRect leftDownCircleFrame = NSMakeRect(rectangle.origin.x - kRADIUS, rectangle.origin.y - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect leftMiddleCircleFrame = NSMakeRect(rectangle.origin.x - kRADIUS, rectangle.origin.y + rectangle.size.height / 2 - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect leftUpCircleFrame = NSMakeRect(rectangle.origin.x - kRADIUS, rectangle.origin.y + rectangle.size.height - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect rightDownCircleFrame = NSMakeRect(rectangle.origin.x + rectangle.size.width - kRADIUS, rectangle.origin.y - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect rightMiddleCircleFrame = NSMakeRect(rectangle.origin.x + rectangle.size.width - kRADIUS, rectangle.origin.y + rectangle.size.height / 2 - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect rightUpCircleFrame = NSMakeRect(rectangle.origin.x + rectangle.size.width - kRADIUS, rectangle.origin.y + rectangle.size.height - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect downMiddleCircleFrame = NSMakeRect(rectangle.origin.x + rectangle.size.width / 2 - kRADIUS, rectangle.origin.y - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    NSRect upMiddleCircleFrame = NSMakeRect(rectangle.origin.x + rectangle.size.width / 2 - kRADIUS, rectangle.origin.y + rectangle.size.height - kRADIUS, kRADIUS * 2, kRADIUS * 2);
    if (NSPointInRect(curPoint, leftDownCircleFrame)) {
        [_resizeRightUpAndLeftDownCursor set];
        _currentEdgeType = SelectBorderAreaEdgeTypeLeftDown;
    } else if (NSPointInRect(curPoint, leftMiddleCircleFrame)) {
        [[NSCursor resizeLeftRightCursor] set];
        _currentEdgeType = SelectBorderAreaEdgeTypeLeft;
    } else if (NSPointInRect(curPoint, leftUpCircleFrame)) {
        [_resizeRightDownAndLeftUpCursor set];
        _currentEdgeType = SelectBorderAreaEdgeTypeLeftUp;
    } else if (NSPointInRect(curPoint, rightDownCircleFrame)) {
        [_resizeRightDownAndLeftUpCursor set];
        _currentEdgeType = SelectBorderAreaEdgeTypeRightDown;
    } else if (NSPointInRect(curPoint, rightMiddleCircleFrame)) {
        [[NSCursor resizeLeftRightCursor] set];
        _currentEdgeType = SelectBorderAreaEdgeTypeRight;
    } else if (NSPointInRect(curPoint, rightUpCircleFrame)) {
        [_resizeRightUpAndLeftDownCursor set];
        _currentEdgeType = SelectBorderAreaEdgeTypeRightUp;
    } else if (NSPointInRect(curPoint, downMiddleCircleFrame)) {
        [[NSCursor resizeUpDownCursor] set];
        _currentEdgeType = SelectBorderAreaEdgeTypeDown;
    } else if (NSPointInRect(curPoint, upMiddleCircleFrame)) {
        [[NSCursor resizeUpDownCursor] set];
        _currentEdgeType = SelectBorderAreaEdgeTypeUp;
    } else {
        _currentEdgeType = SelectBorderAreaEdgeTypeNone;
//        [[NSCursor arrowCursor] set];
        [_dragCursor set];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    [_dragCursor set];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self.superview mouseEntered:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint curPoint = [self.superview convertPoint:[theEvent locationInWindow] toView:nil];
    CGFloat dertX = curPoint.x - _firstPoint.x;
    CGFloat dertY = curPoint.y - _firstPoint.y;
    
    switch (_currentEdgeType) {
        case SelectBorderAreaEdgeTypeRight: {
            [_saDelegate resizeCompleted:NSMakeRect(0.0, 0.0, dertX, 0.0)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeft: {
            [_saDelegate resizeCompleted:NSMakeRect(dertX, 0.0, -dertX, 0.0)];
            break;
        }
        case SelectBorderAreaEdgeTypeUp: {
            [_saDelegate resizeCompleted:NSMakeRect(0.0, 0.0, 0.0, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeDown: {
            [_saDelegate resizeCompleted:NSMakeRect(0.0, dertY, 0.0, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeRightUp: {
            [_saDelegate resizeCompleted:NSMakeRect(0.0, 0.0, dertX, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeRightDown: {
            [_saDelegate resizeCompleted:NSMakeRect(0.0, dertY, dertX, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftUp: {
            [_saDelegate resizeCompleted:NSMakeRect(dertX, 0.0, -dertX, dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftDown: {
            [_saDelegate resizeCompleted:NSMakeRect(dertX, dertY, -dertX, -dertY)];
            break;
        }
        case SelectBorderAreaEdgeTypeNone:
        default: {
            [_saDelegate moveCompleted:NSMakePoint(dertX, dertY)];
            break;
        }
    }
    
    _startPoint = NSZeroPoint;
    _firstPoint = NSZeroPoint;
}

- (void)cursorUpdate:(NSEvent *)event {
    switch (_currentEdgeType) {
        case SelectBorderAreaEdgeTypeRight: {
            [[NSCursor resizeLeftRightCursor] set];
            break;
        }
        case SelectBorderAreaEdgeTypeLeft: {
            [[NSCursor resizeLeftRightCursor] set];
            break;
        }
        case SelectBorderAreaEdgeTypeUp: {
            [[NSCursor resizeUpDownCursor] set];
            break;
        }
        case SelectBorderAreaEdgeTypeDown: {
            [[NSCursor resizeUpDownCursor] set];
            break;
        }
        case SelectBorderAreaEdgeTypeRightUp: {
            [_resizeRightUpAndLeftDownCursor set];
            break;
        }
        case SelectBorderAreaEdgeTypeRightDown: {
            [_resizeRightDownAndLeftUpCursor set];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftUp: {
            [_resizeRightDownAndLeftUpCursor set];
            break;
        }
        case SelectBorderAreaEdgeTypeLeftDown: {
            [_resizeRightUpAndLeftDownCursor set];
            break;
        }
        case SelectBorderAreaEdgeTypeNone:
        default: {
//            [[NSCursor arrowCursor] set];
            [_dragCursor set];
            break;
        }
    }
}

@end

