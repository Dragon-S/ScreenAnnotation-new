//
//  SASeparateLine.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/5/6.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "SASeparateLine.h"

@implementation SASeparateLine

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.boxType = NSBoxCustom;
        self.borderWidth = 0.0;
        [self setBorderWidth:0.0];
        if (self.frame.size.width > 5) {
            [self setFrameSize:NSMakeSize(self.frame.size.width, 1.0)];
            [self setFillColor:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
        } else {
            [self setFrameSize:NSMakeSize(1.0, self.frame.size.height)];
            [self setFillColor:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
        }
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
