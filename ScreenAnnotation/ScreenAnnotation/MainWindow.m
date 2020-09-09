//
//  MainWindow.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect
                            styleMask:NSWindowStyleMaskBorderless
                              backing:backingStoreType
                                defer:flag];
    if (self) {
        self.level = NSStatusWindowLevel;
        self.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.05];//不让鼠标穿透
    }
    
    return self;
}

//启用接受键盘事件
- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;;
}

@end
