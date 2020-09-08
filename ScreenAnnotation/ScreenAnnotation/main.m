//
//  main.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSInteger g_shareScreenIndex = 0;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSString *srceenIndex = [NSString stringWithFormat:@"%s", argv[1]];
        g_shareScreenIndex = [srceenIndex intValue];
    }
    return NSApplicationMain(argc, argv);
}
