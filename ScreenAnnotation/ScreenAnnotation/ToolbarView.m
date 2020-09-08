//
//  ToolbarView.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "ToolbarView.h"

@interface ToolbarView ()

@property (nonatomic, assign) NSPoint firstPoint;
@property (nonatomic, strong) NSColor *windowBackgroundColor;

@end

@implementation ToolbarView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [[NSColor colorWithRed:51.0 / 255.0 green:57.0 / 255.0 blue:63.0 / 255.0 alpha:1.0] CGColor];//背景色
        self.layer.cornerRadius = 4.0;//圆角
        self.layer.borderWidth = 0.0;//边框宽
        
        //阴影
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowColor:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];
        [shadow setShadowOffset:NSMakeSize(0.0, -4.0)];
        [shadow setShadowBlurRadius:20.0];
        self.shadow = shadow;
    }
    
    return self;
}

- (void)awakeFromNib {
    NSTrackingAreaOptions trackingOptions = NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited;
    NSTrackingArea *vvtTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                                   options:trackingOptions
                                                                     owner:self
                                                                  userInfo: nil];
    [self addTrackingArea:vvtTrackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    
}

- (void)mouseExited:(NSEvent *)event {
    [self.superview mouseEntered:event];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    _firstPoint = [[[self window] contentView] convertPoint:[event locationInWindow] toView:self];
    self.windowBackgroundColor = self.window.backgroundColor;
    [[self window] setBackgroundColor:[NSColor clearColor]];
    [self.window makeFirstResponder:self.window];
    [super mouseDown:event];
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint point = [[[self window] contentView] convertPoint:[event locationInWindow] toView:self];
    NSPoint offset = NSMakePoint(point.x - _firstPoint.x, point.y - _firstPoint.y);
    NSPoint origin = self.frame.origin;
    NSPoint newPoint = NSMakePoint(origin.x + offset.x, origin.y + offset.y);
    NSSize size = self.frame.size;
    NSSize superViewSize = [[self window] contentView].frame.size;
    
    if (newPoint.x <= 3) {
        newPoint.x = 3;
    }
    
    if (newPoint.y <= 3) {
        newPoint.y = 3;
    }
    
    if (newPoint.x + size.width + 3 >= superViewSize.width) {
        newPoint.x = superViewSize.width - size.width - 3;
    }
    
    if (newPoint.y + size.height + 3 >= superViewSize.height) {
        newPoint.y = superViewSize.height - size.height - 3;
    }
    
    [self setFrameOrigin:newPoint];
    [[self window] setBackgroundColor:[NSColor clearColor]];
    [[self window] setBackgroundColor:_windowBackgroundColor];
}

- (void)mouseUp:(NSEvent *)event {
    [[self window] setBackgroundColor:self.windowBackgroundColor];
}

@end
