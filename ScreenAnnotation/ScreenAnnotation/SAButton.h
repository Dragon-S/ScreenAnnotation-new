//
//  SAButton.h
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAButton : NSButton

@property (nonatomic, assign) BOOL canSelected;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
