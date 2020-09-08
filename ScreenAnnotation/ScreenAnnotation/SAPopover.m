//
//  SAPopover.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/5/7.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "SAPopover.h"

@implementation SAPopover

- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {
    [super showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
    NSView *popoverView = [[[self contentViewController] view] superview];
    [popoverView setWantsLayer:YES];
    [[popoverView layer] setBackgroundColor:[[NSColor colorWithRed:51.0 / 255.0 green:57.0 / 255.0 blue:63.0 / 255.0 alpha:1.0] CGColor]];
}

@end
