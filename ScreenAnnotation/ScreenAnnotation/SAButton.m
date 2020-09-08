//
//  SAButton.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "SAButton.h"

@interface SAButton ()

@property (nonatomic, strong) NSTrackingArea *trackingArea;
@property (nonatomic, strong) NSImage *defaultImage;
@property (nonatomic, copy) NSAttributedString *defaultAttributedTitle;

@end

@implementation SAButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self.cell setHighlightsBy:NSContentsCellMask];
        _selected = NO;
        _canSelected = NO;
        _defaultImage = self.image;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    NSMutableAttributedString *attributedAlternateTitle = [[NSMutableAttributedString alloc] initWithString:self.title];
    NSUInteger length = [attributedAlternateTitle length];
    NSRange range = NSMakeRange(0, length);
    [attributedAlternateTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithRed:0.0 green:188.0 / 255.0 blue:229.0 / 255 alpha:1.0] range:range];
    [attributedAlternateTitle fixAttributesInRange:range];
    self.attributedAlternateTitle = attributedAlternateTitle;
    
    _defaultAttributedTitle = self.attributedTitle;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if(self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectZero options:options owner:self userInfo:nil];
    
    [self addTrackingArea:self.trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    self.layer.backgroundColor = [[NSColor colorWithWhite:1.0 alpha:0.1] CGColor];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    self.layer.backgroundColor = [[NSColor colorWithWhite:1.0 alpha:0.0] CGColor];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [self.window makeFirstResponder:self.window];
}

- (void)setSelected:(BOOL)selected {
    if (_canSelected) {
        if (_selected != selected) {
            _selected = selected;
            
            [self updateImage];
        }
    }
}

- (void)updateImage {
    if (_selected) {
        self.image = self.alternateImage;
        self.attributedTitle = self.attributedAlternateTitle;
    } else {
        self.image = self.defaultImage;
        self.attributedTitle = self.defaultAttributedTitle;
    }
}

@end
