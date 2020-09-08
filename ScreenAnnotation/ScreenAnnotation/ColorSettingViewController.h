//
//  ColorSettingViewController.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SettingsDataBlock)(NSImage *colorIconImage, NSImage *colorIconAlterImage, NSColor *color, NSFont *font, NSInteger lineWidth);

@interface ColorSettingViewController : NSViewController

@property (nonatomic, strong) SettingsDataBlock settingsDataBlock;

@end

NS_ASSUME_NONNULL_END
