//
//  DrawingView.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingView.h"
//#import "DrawingLayer.h"

@interface DrawingView ()

//@property (nonatomic, strong) DrawingLayer *drawingLayer;
@property (nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation DrawingView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.wantsLayer = YES;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if(self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectZero options:options owner:self userInfo:nil];
    
    [self addTrackingArea:self.trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    [super mouseEntered:event];
}

//- (void)mouseDown:(NSEvent *)event {
//    NSPoint point = [[[self window] contentView] convertPoint:[event locationInWindow] toView:self];
//    _drawingLayer = [[DrawingLayer alloc] init];
//    [_drawingLayer movePathWithStartPoint:point];
//
//    [self.layer addSublayer:_drawingLayer];
//}
//
//- (void)mouseDragged:(NSEvent *)event {
//    NSPoint point = [[[self window] contentView] convertPoint:[event locationInWindow] toView:self];
//    [_drawingLayer movePathWithEndPoint:point];
//}
//
//- (void)mouseUp:(NSEvent *)event {
//    NSPoint point = [[[self window] contentView] convertPoint:[event locationInWindow] toView:self];
//    [_drawingLayer movePathWithEndPoint:point];
//}

@end
