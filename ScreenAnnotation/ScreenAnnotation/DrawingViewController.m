//
//  DrawingViewController.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "DrawingViewController.h"
#import "DrawingView.h"
#import "DrawingLayer.h"
#import "SATextField.h"
#import "SelectBorderView.h"

static NSCursor *getCursorWithToolType(ToolType toolType, DrawingType drawingType){
    NSCursor *cursor = [NSCursor arrowCursor];
    NSImage *cursorImage = nil;
    switch (toolType) {
        case ToolTypeMouse: {
            break;
        }
        case ToolTypeSelect: {
            cursorImage = [NSImage imageNamed:@"mouse-move"];
            break;
        }
        case ToolTypeSpotlight: {
            cursorImage = [NSImage imageNamed:@"mouse-spotlight"];
            break;
        }
        case ToolTypePen: {
            cursorImage = [NSImage imageNamed:@"mouse-brush"];
            break;
        }
        case ToolTypeText: {
            cursorImage = [NSImage imageNamed:@"mouse-text"];
            break;
        }
        case ToolTypeShape: {
            switch (drawingType) {
                case DrawingTypeArrow:
                case DrawingTypeLine: {
                    cursorImage = [NSImage imageNamed:@"mouse-line"];
                    break;
                }
                case DrawingTypeOval: {
                    cursorImage = [NSImage imageNamed:@"mouse-circle"];
                    break;
                }
                case DrawingTypeRect: {
                    cursorImage = [NSImage imageNamed:@"mouse-rectangle"];
                    break;
                }
                case DrawingTypeCorrectMark: {
                    cursorImage = [NSImage imageNamed:@"mouse-correct"];
                    break;
                }
                case DrawingTypeErrorMark: {
                    cursorImage = [NSImage imageNamed:@"mouse-error"];
                    break;
                }
                case DrawingTypeHeartMark: {
                    cursorImage = [NSImage imageNamed:@"mouse-heart"];
                    break;
                }
                case DrawingTypeQuestionMark: {
                    cursorImage = [NSImage imageNamed:@"mouse-why"];
                    break;
                }
                    
                default: {
                    break;
                }
            }
            break;
        }
        case ToolTypeErase: {
            cursorImage = [NSImage imageNamed:@"mouse-eraser"];
            break;
        }
            
        default: {
            break;
        }
    }
    
    if (cursorImage != nil) {
        NSPoint hotSpot = NSMakePoint(cursorImage.size.width / 2, cursorImage.size.height / 2);
        //FIXME 画笔和橡皮擦笔触点改为笔刷顶端，目前的数值与图片大小及图片内容的位置有关，暂时使用魔法数，需要在修改
        if (toolType == ToolTypePen || toolType == ToolTypeErase) {
            hotSpot.x = 9;
            hotSpot.y = 26;
        }
        cursor = [[NSCursor alloc] initWithImage:cursorImage hotSpot:hotSpot];
    }
    
    return cursor;
}

@interface DrawingViewController () <SATextFieldNotifyingDelegate, SelectBorderViewDelegate>

@property (nonatomic, weak) IBOutlet DrawingView *drawingView;

@property (nonatomic) DrawingLayer *drawingLayer;
@property (nonatomic) SATextField *textField;

@property (nonatomic, strong) NSMutableArray *drawingArray;
@property (nonatomic, strong) NSMutableArray *removeAllArray;//全部清除时，undo机制用

@property (nonatomic, strong) DrawingLayer *selectDrawingLayer;
@property (nonatomic, strong) SATextField *selectedTextField;
@property (nonatomic, strong) SelectBorderView *selectBorderView;

@property (nonatomic, strong) NSCursor *currentCursor;

@end

@implementation DrawingViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.drawingArray = [NSMutableArray array];
        self.removeAllArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupTrackArea {
    NSTrackingAreaOptions trackingOptions = NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited;
    NSTrackingArea *vvtTrackingArea = [[NSTrackingArea alloc] initWithRect:_drawingView.bounds
                                                                   options: trackingOptions
                                                                     owner:_drawingView
                                                                  userInfo: nil];
    [_drawingView addTrackingArea: vvtTrackingArea];
}

- (void)setCurrentCursor:(NSCursor *)currentCursor {
    _currentCursor = nil;
    _currentCursor = currentCursor;
    
    [_currentCursor set];
}

- (void)mouseExited:(NSEvent *)event {
//    [super mouseExited:event];
    self.currentCursor = [NSCursor arrowCursor];
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    self.currentCursor = getCursorWithToolType(_toolType, _drawingType);
    [self.currentCursor set];
}

- (void)selectDrawingLayer:(NSPoint)point {
    [self clearSelectStatus];
    NSArray *sublayers = [_drawingView.layer sublayers];
    for (CALayer *layer in sublayers) {
        if ([layer isKindOfClass:[DrawingLayer class]]) {
            if ([(DrawingLayer *)layer containsPoint:point]) {
                _selectDrawingLayer = (DrawingLayer *)layer;
                break;
            }
        }
    }
    
    if (_selectDrawingLayer) {
        CGRect rect = CGRectInset(_selectDrawingLayer.bezierPath.bounds, -(_selectDrawingLayer.bezierPath.lineWidth), -(_selectDrawingLayer.bezierPath.lineWidth));
        _selectBorderView = [[SelectBorderView alloc] initWithFrame:rect];
        [_selectBorderView setSaDelegate:self];
        [_drawingView addSubview:_selectBorderView];
    }
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint point = [[[_drawingView window] contentView] convertPoint:[event locationInWindow] toView:_drawingView];
    [self.view.window makeFirstResponder:self.view.window];
    
    //如果是绘制文字
    if (_toolType == ToolTypeText) {
        _textField = [[SATextField alloc] initWithFrame:NSMakeRect(point.x, point.y, 100, [_drawingFont pointSize])];
        [_textField setTextColor:_drawingColor];
        [_textField setFont:_drawingFont];
        [_textField setSaDelegate:self];
    } else if ((_toolType == ToolTypePen) || (_toolType == ToolTypeShape)) {
        _drawingLayer = [DrawingLayer createDrawingLayerWith:_drawingType];
        _drawingLayer.lineWidth = self.drawingLineWidth;
        _drawingLayer.strokeColor = self.drawingColor.CGColor;
        
        [self.drawingLayer movePathWithStartPoint:point];
        [_drawingView.layer addSublayer:_drawingLayer];
    } else if (_toolType == ToolTypeErase) {
        [self removeDrawingLayer:point];
    } else if (_toolType == ToolTypeSelect) {
        NSColor *color = [[self.view window] backgroundColor];
        [self selectDrawingLayer:point];
        if (_selectBorderView) {
            [_selectBorderView mouseDown:event];
        }
        [self.view.window setBackgroundColor:[NSColor clearColor]];
        [self.view.window setBackgroundColor:color];
    }
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint newDragLocation = [[[_drawingView window] contentView] convertPoint:[event locationInWindow] toView:_drawingView];
    if ((_toolType == ToolTypePen) || (_toolType == ToolTypeShape)) {
        [_drawingLayer movePathWithMovePoint:newDragLocation];
    } else if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            [_selectBorderView mouseDragged:event];
        }
    }
}

- (void)mouseUp:(NSEvent *)event {
    if ((_toolType == ToolTypeShape) || (_toolType == ToolTypePen)) {
        if (self.drawingLayer) {
            NSPoint point = [[[_drawingView window] contentView] convertPoint:[event locationInWindow] toView:_drawingView];
            [_drawingLayer movePathWithEndPoint:point];
            
            [self.drawingLayer removeFromSuperlayer];
            [self addDrawingObject:_drawingLayer];
        }
    } else if (_toolType == ToolTypeText) {
        if (self.textField) {
            [self addDrawingObject:_textField];
        }
    } else if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            [_selectBorderView mouseUp:event];
        }
    }
}

- (void)removeDrawingLayer:(CGPoint)point {
    NSArray *sublayers = [_drawingView.layer sublayers];
    DrawingLayer *clickedLayer = nil;
    for (CALayer *layer in sublayers) {
        if ([layer isKindOfClass:[DrawingLayer class]]) {
            if ([(DrawingLayer *)layer containsPoint:point]) {
                clickedLayer = (DrawingLayer *)layer;
                break;
            }
        }
    }
    if (clickedLayer != nil) {
        [self removeDrawingObject:clickedLayer];
    }
}

- (void)moveDrawingObject:(id)drawingObject withOffsetPoint:(NSPoint)offsetPoint isFirst:(BOOL)isFirst {
    [[self.undoManager prepareWithInvocationTarget:self] moveDrawingObject:drawingObject withOffsetPoint:NSMakePoint(-offsetPoint.x, -offsetPoint.y) isFirst:NO];
    if (!isFirst) {
        NSColor *color = [[self.view window] backgroundColor];
        if ([drawingObject isKindOfClass:[SATextField class]]) {
            [drawingObject moveOffsetPoint:offsetPoint];
        } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
            [drawingObject moveBy:offsetPoint];
        }
        [self.view.window setBackgroundColor:[NSColor clearColor]];
        [self.view.window setBackgroundColor:color];
    }
}

- (void)resizeDrawingObject:(id)drawingObject withOffsetRect:(NSRect)offsetRect isFirst:(BOOL)isFirst {
    [[self.undoManager prepareWithInvocationTarget:self] resizeDrawingObject:drawingObject withOffsetRect:NSMakeRect(-offsetRect.origin.x, -offsetRect.origin.y, -offsetRect.size.width, -offsetRect.size.height) isFirst:NO];
    
    if (!isFirst) {
        NSColor *color = [[self.view window] backgroundColor];
        if ([drawingObject isKindOfClass:[SATextField class]]) {
            [drawingObject resizeOffsetRect:offsetRect];
        } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
            [drawingObject resizeBy:offsetRect];
        }
        [self.view.window setBackgroundColor:[NSColor clearColor]];
        [self.view.window setBackgroundColor:color];
    }
}

- (void)addDrawingObject:(id)drawingObject {
    [[self.undoManager prepareWithInvocationTarget:self] removeDrawingObject:drawingObject];
    if ([drawingObject isKindOfClass:[SATextField class]]) {
        [_drawingView addSubview:drawingObject];
        [_drawingView.window makeFirstResponder:drawingObject];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEnd:) name:NSControlTextDidEndEditingNotification object:drawingObject];
    } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
        [_drawingView.layer addSublayer:drawingObject];
    }
    [self.drawingArray addObject:drawingObject];
}

- (void)removeDrawingObject:(id)drawingObject {
    [[self.undoManager prepareWithInvocationTarget:self] addDrawingObject:drawingObject];
    
    NSColor *color = [[self.view window] backgroundColor];
    if ([drawingObject isKindOfClass:[SATextField class]]) {
        [drawingObject removeFromSuperview];
    } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
        [drawingObject removeFromSuperlayer];
    }
    [self.view.window setBackgroundColor:[NSColor clearColor]];
    [self.view.window setBackgroundColor:color];
    
    [self.drawingArray removeObject:drawingObject];
}

- (void)removeAllDrawingObject:(NSMutableArray *)drawingArray {
    [[self.undoManager prepareWithInvocationTarget:self] addAllDrawingObject:drawingArray];
    
    NSColor *color = [[self.view window] backgroundColor];
    for (id drawingObject in drawingArray) {
        if ([drawingObject isKindOfClass:[SATextField class]]) {
            [drawingObject removeFromSuperview];
        } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
            [drawingObject removeFromSuperlayer];
        }
    }
    [self.view.window setBackgroundColor:[NSColor clearColor]];
    [self.view.window setBackgroundColor:color];
    
    [self.removeAllArray removeObjectsInArray:drawingArray];
}

- (void)addAllDrawingObject:(NSMutableArray *)drawingArray {
    [[self.undoManager prepareWithInvocationTarget:self] removeAllDrawingObject:drawingArray];
    for (id drawingObject in drawingArray) {
        if ([drawingObject isKindOfClass:[SATextField class]]) {
            [_drawingView addSubview:drawingObject];
        } else if ([drawingObject isKindOfClass:[DrawingLayer class]]) {
             [_drawingView.layer addSublayer:drawingObject];
        }
    }
    [self.removeAllArray addObjectsFromArray:drawingArray];
}

#pragma mark NSControlTextDidEndEditingNotification
- (void)textFieldDidEnd:(NSNotification *)notification {
    SATextField *textField = [notification object];
    if (textField.stringValue.length == 0) {
        [self removeDrawingObject:textField];;
    }
}

#pragma mark SelectBorderViewDelegate
- (void)moveWithOffsetPoint:(NSPoint)offsetPoint {
    if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            if (_selectedTextField) {
                [_selectedTextField moveOffsetPoint:offsetPoint];
            } else if (_selectDrawingLayer) {
                [_selectDrawingLayer moveBy:offsetPoint];
            }
        }
    }
}

- (void)moveCompleted:(NSPoint)offsetPoint {
    if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            if (_selectedTextField) {
                [self moveDrawingObject:_selectedTextField withOffsetPoint:offsetPoint isFirst:YES];
            } else if (_selectDrawingLayer) {
                [self moveDrawingObject:_selectDrawingLayer withOffsetPoint:offsetPoint isFirst:YES];
            }
        }
    }
}

- (void)resizeWithOffsetRect:(NSRect)offsetRect {
    if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            if (_selectedTextField) {
                [_selectedTextField resizeOffsetRect:offsetRect];
            } else if (_selectDrawingLayer) {
                [_selectDrawingLayer resizeBy:offsetRect];
            }
        }
    }
}

- (void)resizeCompleted:(NSRect)offsetRect {
    if (_toolType == ToolTypeSelect) {
        if (_selectBorderView) {
            if (_selectedTextField) {
                [self resizeDrawingObject:_selectedTextField withOffsetRect:offsetRect isFirst:YES];
            } else if (_selectDrawingLayer) {
                [self resizeDrawingObject:_selectDrawingLayer withOffsetRect:offsetRect isFirst:YES];
            }
        }
    }
}

#pragma mark SATextFieldNotifyingDelegate
//橡皮擦擦除文字
- (void)textFieldMouseDown:(NSTextField *)textField event:(nonnull NSEvent *)event {
    if (textField) {
        if (_toolType == ToolTypeErase) {
            [self removeDrawingObject:textField];
        } else if (_toolType == ToolTypeText) {
            [[_drawingView window] makeFirstResponder:textField];
        } else if (_toolType == ToolTypeSelect) {
            [self clearSelectStatus];
            _selectedTextField = (SATextField *)textField;
            if (_selectedTextField) {
                _selectBorderView = [[SelectBorderView alloc]initWithFrame:_selectedTextField.frame];
                [_selectBorderView setSaDelegate:self];
                [_drawingView addSubview:_selectBorderView];
            }
            if (_selectBorderView) {
                [_selectBorderView mouseDown:event];
            }
        }
    }
}

- (void)textFieldMouseDragged:(NSTextField *)textField event:(NSEvent *)event {
    if (_toolType == ToolTypeSelect) {
        if (_selectedTextField) {
            if (_selectBorderView) {
                [_selectBorderView mouseDragged:event];
            }
        }
    }
}

#pragma mark public function

- (void)redo:(id)sender {
    [self.undoManager redo];
}

- (void)undo:(id)sender {
    [self.undoManager undo];
}

- (void)removeAll {
    [self removeAllDrawingObject:_drawingArray];
}

- (void)setTextFieldEditable:(BOOL)editable {
    for (NSView *view in _drawingView.subviews) {
        if ([view isKindOfClass:[SATextField class]]) {
            SATextField *textField = (SATextField *)view;
            [textField setSelectable:editable];
            [textField setEditable:editable];
        }
    }
}

- (void)clearSelectStatus {
    _selectDrawingLayer = nil;
    _selectedTextField = nil;
    [_selectBorderView removeFromSuperview];
    _selectBorderView = nil;
}

@end
