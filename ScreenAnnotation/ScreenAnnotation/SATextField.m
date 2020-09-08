//
//  SATextField.m
//  ScreenAnnotation
//
//  Created by Lorne on 2020/4/7.
//  Copyright © 2020 Lorne. All rights reserved.
//

#import "SATextField.h"

@interface SATextField()

@end

@implementation SATextField

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setBackgroundColor:[NSColor clearColor]];
        [self setBordered:NO];
        [self setEditable:YES];
        [self setLineBreakMode:NSLineBreakByCharWrapping];
        [self setPlaceholderString:@"请在此处输入文字"];
        [self setContinuous:YES];
    }
    
    return self;
}

- (void)textDidChange:(NSNotification *)notification {
    NSDictionary *attrs = @{NSFontAttributeName : self.font};
    NSRect textRect = [[self stringValue] boundingRectWithSize:NSMakeSize(1024, 768)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attrs];
    textRect.size.width = textRect.size.width + self.font.pointSize;

    [self setFrameSize:textRect.size];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
    if (_saDelegate) {
        [_saDelegate textFieldMouseDown:self event:event];
    }
}

- (void)mouseDragged:(NSEvent *)event {
    if (_saDelegate) {
        [_saDelegate textFieldMouseDragged:self event:event];
    }
}

- (void)mouseUp:(NSEvent *)event {
    //点击文字时，up事件穿透传递给父view重复添加控件
}

- (void)moveOffsetPoint:(NSPoint)offsetPoint {
    NSPoint newOrigin = NSMakePoint(self.frame.origin.x + offsetPoint.x, self.frame.origin.y + offsetPoint.y);
    [self setFrameOrigin:newOrigin];
    [self setNeedsDisplay:YES];
}

- (void)resizeOffsetRect:(NSRect)offsetRect {
    NSRect newFrame = NSMakeRect(self.frame.origin.x + offsetRect.origin.x, self.frame.origin.y + offsetRect.origin.y, self.frame.size.width + offsetRect.size.width, self.frame.size.height + offsetRect.size.height);
    [self setFrame:newFrame];
    [self setNeedsDisplay:YES];
}

@end
