//
//  MainWindowController.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "MainWindowController.h"
#import "ToolbarViewController.h"
#import "DrawingViewController.h"

extern NSInteger g_shareScreenIndex;

@interface MainWindowController ()

@property (nonatomic, strong) ToolbarViewController *toolbarViewController;

@end

@implementation MainWindowController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
//        NSStoryboard *mainStoryboard = [NSStoryboard mainStoryboard];
        NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _toolbarViewController = [mainStoryboard instantiateControllerWithIdentifier:@"ToolbarViewController"];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    //设置窗口大小为屏幕大小
    NSArray<NSScreen *> *screens = [NSScreen screens];
    if ((g_shareScreenIndex > screens.count - 1) || (g_shareScreenIndex < 0)) {
        g_shareScreenIndex = 0;//如果屏幕index传递无效值，则默认选择主屏
    }
    
    NSRect frame = [[screens objectAtIndex:g_shareScreenIndex] frame];
    [[self window] setFrame:frame display:YES];
//    for (NSScreen *screen in [NSScreen screens]) {
//        NSRect frame = [[NSScreen mainScreen] frame];
//        [[self window] setFrame:frame display:YES];
//    }
//    [NSScreen screens];
//    NSRect frame = [[NSScreen mainScreen] frame];
////    frame.size = NSMakeSize(800, 800);
//    [[self window] setFrame:frame display:YES];
    
    
    //显示toolbarview
    NSView *mainWindowView = [[self window] contentView];
    NSView *toolbarView = [_toolbarViewController view];
    NSRect toobarViewFrame = [toolbarView frame];
    NSRect drawingViewFrame = [mainWindowView frame];
    NSPoint toobarViewFrameOrigin = NSMakePoint((drawingViewFrame.size.width - toobarViewFrame.size.width) / 2, 80);
    [toolbarView setFrameOrigin:toobarViewFrameOrigin];
    [toolbarView setNeedsDisplay:YES];

    [mainWindowView addSubview:toolbarView];
    [(DrawingViewController *)self.contentViewController setupTrackArea];
    
    [_toolbarViewController setDrawingViewController:self.contentViewController];
}

@end
