//
//  ShapeSettingViewController.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SATypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DrawingTypeBlock)(NSImage *shapeIconImage, NSImage *shapeIconAlterImage, DrawingType drawingType);

@interface ShapeSettingViewController : NSViewController

@property (nonatomic, strong) DrawingTypeBlock drawingTypeBlock;

@end

NS_ASSUME_NONNULL_END
