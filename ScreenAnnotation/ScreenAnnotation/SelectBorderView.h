//
//  SelectBorderView.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/19.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectBorderViewDelegate <NSObject>

- (void)moveWithOffsetPoint:(NSPoint)offsetPoint;
- (void)resizeWithOffsetRect:(NSRect)offsetRect;
- (void)moveCompleted:(NSPoint)offsetPoint;
- (void)resizeCompleted:(NSRect)offsetRect;

@end

@interface SelectBorderView : NSView

@property (nonatomic, weak) id<SelectBorderViewDelegate> saDelegate;

- (void)vvtAddTrackingArea;
- (void)vvtRemoveTrackingArea;

@end

NS_ASSUME_NONNULL_END
