//
//  DrawingViewController.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SATypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawingViewController : NSViewController

@property (nonatomic, assign) ToolType toolType;
@property (nonatomic, assign) DrawingType drawingType;
@property (nonatomic, assign) NSInteger drawingLineWidth;
@property (nonatomic, strong) NSColor *drawingColor;
@property (nonatomic, strong) NSFont *drawingFont;

- (void)redo:(id)sender;
- (void)undo:(id)sender;
- (void)removeAll;

- (void)setTextFieldEditable:(BOOL)editable;
- (void)clearSelectStatus;

- (void)setupTrackArea;

@end

NS_ASSUME_NONNULL_END
