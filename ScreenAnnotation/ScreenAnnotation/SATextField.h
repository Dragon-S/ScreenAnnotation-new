//
//  SATextField.h
//  ScreenAnnotation
//
//  Created by Lorne on 2020/4/7.
//  Copyright © 2020 Lorne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@class SATextField;

@protocol SATextFieldNotifyingDelegate <NSObject>

- (void)textFieldMouseDown:(NSTextField *_Nullable)textField event:(NSEvent *)event;
- (void)textFieldMouseDragged:(NSTextField *_Nullable)textField event:(NSEvent *)event;

@end

@interface SATextField : NSTextField

@property (nullable, weak) id<SATextFieldNotifyingDelegate> saDelegate;

- (void)moveOffsetPoint:(NSPoint)offsetPoint;
- (void)resizeOffsetRect:(NSRect)offsetRect;

@end

NS_ASSUME_NONNULL_END
