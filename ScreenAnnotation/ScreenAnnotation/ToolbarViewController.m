//
//  ToolbarViewController.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "ToolbarViewController.h"
#import "ShapeSettingViewController.h"
#import "ColorSettingViewController.h"
#import "DrawingViewController.h"
#import "SAButton.h"
#import "SATypeDefine.h"
#import "SAPopover.h"

static void saveImage(NSImage *image) {
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0]
                                                           forKey:NSImageCompressionFactor];
    NSData *pngData = [newRep representationUsingType:NSBitmapImageFileTypePNG
                                           properties:imageProps];

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    NSString *pictureDir = [paths objectAtIndex:0];
    NSString *dirPath = [pictureDir stringByAppendingString:@"/zhangyu"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png", dirPath, strDate];
    NSLog(@"filePath = %@",filePath);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    //查找目录，如果没有就创建一个目录
    if (![fileManager fileExistsAtPath: dirPath]) {
        NSError *error = nil;
        BOOL isSuccess = [fileManager createDirectoryAtPath: dirPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&error];
        NSLog(@"error = %@",error);
        NSLog(@"isSiccess = %d",isSuccess);
    }

    NSError *error = nil;
    BOOL isSuccess = [pngData writeToFile:filePath options:NSDataWritingAtomic
                                    error:&error];
    if (isSuccess && error == nil) {
        NSLog(@"存储成功！！！");
    } else {
        NSLog(@"error = %@",error);
        NSLog(@"存储失败！！！");
    }
}

@interface ToolbarViewController ()

@property (nonatomic, strong) SAPopover *shapeSettingPopover;
@property (nonatomic, strong) SAPopover *colorSettingPopover;
@property (nonatomic, strong) ShapeSettingViewController *shapeSettingViewController;
@property (nonatomic, strong) ColorSettingViewController *colorSettingViewController;

@property (nonatomic, weak) IBOutlet NSButton *closeBtn;

@property (nonatomic, weak) IBOutlet SAButton *mouseBtn;
@property (nonatomic, weak) IBOutlet SAButton *selectBtn;
@property (nonatomic, weak) IBOutlet SAButton *penBtn;
@property (nonatomic, weak) IBOutlet SAButton *textBtn;
@property (nonatomic, weak) IBOutlet SAButton *shapeBtn;
@property (nonatomic, weak) IBOutlet SAButton *colorBtn;
@property (nonatomic, weak) IBOutlet SAButton *eraserBtn;
@property (nonatomic, weak) IBOutlet SAButton *undoBtn;
@property (nonatomic, weak) IBOutlet SAButton *redoBtn;
@property (nonatomic, weak) IBOutlet SAButton *clearBtn;
@property (nonatomic, weak) IBOutlet SAButton *saveBtn;

@property (nonatomic, assign) ToolType currentToolType;
@property (nonatomic, assign) DrawingType currentDrawingType;
@property (nonatomic, strong) NSColor *currentColor;
@property (nonatomic, assign) NSInteger currentLineWidth;
@property (nonatomic, strong) NSFont *currentFont;

@property (nonatomic, strong) NSColorPanel *colorPanel;

@property (nonatomic, strong) NSStatusItem *appStatusItem;
@property (nonatomic, strong) IBOutlet NSMenu *statusBarMenu;
@property (nonatomic, strong) IBOutlet NSMenuItem *toggleMenuItem;
@property (nonatomic, strong) IBOutlet NSMenuItem *quitMenuItem;

@property (nonatomic, strong) NSData *saveImageData;

- (IBAction)buttonAction:(id)sender;
- (IBAction)toggleToolbar:(id)sender;
- (IBAction)quitAnnotation:(id)sender;

- (void)showShapeSettingPanel:(id)sender;
- (void)showColorSettingPanel:(id)sender;

@end

@implementation ToolbarViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
//        NSStoryboard *mainStoryboard = [NSStoryboard mainStoryboard];
        NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _shapeSettingViewController = [mainStoryboard instantiateControllerWithIdentifier:@"ShapeSettingViewController"];
        _colorSettingViewController = [mainStoryboard instantiateControllerWithIdentifier:@"ColorSettingViewController"];
        _shapeSettingPopover = [[SAPopover alloc] init];
        _colorSettingPopover = [[SAPopover alloc] init];
        
        _colorPanel = [NSColorPanel sharedColorPanel];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _shapeSettingPopover.behavior = NSPopoverBehaviorTransient;
//    _shapeSettingPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    _colorSettingPopover.behavior = NSPopoverBehaviorTransient;
//    _colorSettingPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    //设置button的tag
    [_mouseBtn setTag:ToolTypeMouse];
    [_mouseBtn setTitle:NSLocalizedString(@"Mouse", nil)];
    [_mouseBtn setCanSelected:YES];
    [_selectBtn setTag:ToolTypeSelect];
    [_selectBtn setTitle:NSLocalizedString(@"Select", nil)];
    [_selectBtn setCanSelected:YES];
    [_penBtn setTag:ToolTypePen];
    [_penBtn setTitle:NSLocalizedString(@"Pen", nil)];
    [_penBtn setCanSelected:YES];
    [_textBtn setTag:ToolTypeText];
    [_textBtn setTitle:NSLocalizedString(@"Text", nil)];
    [_textBtn setCanSelected:YES];
    [_shapeBtn setTag:ToolTypeShape];
    [_shapeBtn setTitle:NSLocalizedString(@"Shape", nil)];
    [_shapeBtn setCanSelected:YES];
    [_colorBtn setTag:ToolTypeColor];
    [_colorBtn setTitle:NSLocalizedString(@"Format", nil)];
    [_eraserBtn setTag:ToolTypeErase];
    [_eraserBtn setCanSelected:YES];
    [_eraserBtn setTitle:NSLocalizedString(@"Eraser", nil)];
    [_undoBtn setTag:ToolTypeUndo];
    [_undoBtn setTitle:NSLocalizedString(@"Undo", nil)];
    [_redoBtn setTag:ToolTypeRedo];
    [_redoBtn setTitle:NSLocalizedString(@"Redo", nil)];
    [_clearBtn setTag:ToolTypeClear];
    [_clearBtn setTitle:NSLocalizedString(@"Clear", nil)];
    [_saveBtn setTag:ToolTypeSave];
    [_saveBtn setTitle:NSLocalizedString(@"Save", nil)];
    
    __weak __typeof(&*self)weakSelf = self;
    _shapeSettingViewController.drawingTypeBlock = ^(NSImage *shapeIconImage, NSImage *shapeIconAlterImage, DrawingType drawingType) {
        __strong __typeof(&*self)strongSelf = weakSelf;
        strongSelf.currentDrawingType = ((DrawingViewController *)strongSelf.drawingViewController).drawingType = drawingType;
        strongSelf.shapeBtn.image = shapeIconImage;
        strongSelf.shapeBtn.alternateImage = shapeIconAlterImage;
        [strongSelf.shapeSettingPopover close];
    };
    
    _colorSettingViewController.settingsDataBlock = ^(NSImage * _Nonnull colorIconImage, NSImage * _Nonnull colorIconAlterImage, NSColor * _Nonnull color, NSFont * _Nonnull font, NSInteger lineWidth) {
                __strong __typeof(&*self)strongSelf = weakSelf;
        strongSelf.currentFont = ((DrawingViewController *)strongSelf.drawingViewController).drawingFont = font;
        strongSelf.currentColor = ((DrawingViewController *)strongSelf.drawingViewController).drawingColor = color;
        strongSelf.currentLineWidth = ((DrawingViewController *)strongSelf.drawingViewController).drawingLineWidth = lineWidth;
        strongSelf.colorBtn.image = colorIconAlterImage;
        strongSelf.colorBtn.alternateImage = colorIconAlterImage;
        [strongSelf.colorSettingPopover close];
    };
    [_colorSettingViewController view];//调用此方法后可以直接出发viewcontroller的viewdidload
    
    [NSColorPanel setPickerMask:NSColorPanelCrayonModeMask];
    [NSColorPanel setPickerMode:NSColorPanelModeCrayon];
    
    _colorPanel.color = [NSColor redColor];
    _colorPanel.showsAlpha = YES;
    [_colorPanel setTarget:self];
    [_colorPanel setAction:@selector(didchangeColor:)];
    [_colorPanel setTarget:self];
    
    //在状态栏中显示程序图标
//    _appStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//    NSImage *icon = [NSImage imageNamed:@"statusbarIcon"];
//    [icon setTemplate:true];
//    _appStatusItem.button.image = [NSImage imageNamed:@"statusbarIcon"];
//    _appStatusItem.menu = _statusBarMenu;
//    _toggleMenuItem.title = NSLocalizedString(@"Hide Toolbar", nil);
//    _quitMenuItem.title = NSLocalizedString(@"Quit", nil);
    
    [[_closeBtn cell] setHighlightsBy:NSContentsCellMask];
}

- (IBAction)didchangeColor:(id)sender {    
    _currentColor = [sender color];
    ((DrawingViewController *)_drawingViewController).drawingColor = _currentColor;
}

- (void)setDrawingViewController:(NSViewController *)drawingViewController {
    _drawingViewController = drawingViewController;
    
    NSUndoManager *undoManager = _drawingViewController.undoManager;
    _redoBtn.enabled = undoManager.canRedo;
    _undoBtn.enabled = undoManager.canUndo;
    
    [self setupDefaultParam];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerUndoManager:) name:NSUndoManagerCheckpointNotification object:_drawingViewController.undoManager];
}

- (void)observerUndoManager:(NSNotification *)notification {
    NSUndoManager *undoManager = [notification object];
    _redoBtn.enabled = undoManager.canRedo;
    _undoBtn.enabled = undoManager.canUndo;
}

- (void)setupDefaultParam {
    [self clearSelectedBtnState];
    [_penBtn setSelected:YES];
//    [_penBtn setTitle:NSLocalizedString(@"Pen", nil)];
    
    DrawingViewController *drawingViewController = (DrawingViewController *)[[[self view] window] contentViewController];
    drawingViewController.toolType = _currentToolType = ToolTypePen;
    drawingViewController.drawingType = _currentDrawingType = DrawingTypeGraffiti;
    drawingViewController.drawingLineWidth = _currentLineWidth;
    drawingViewController.drawingColor = _currentColor;
    drawingViewController.drawingFont = _currentFont;
    
    [[self.view window] setBackgroundColor:[NSColor colorWithWhite:1.0 alpha:0.05]];
}

- (void)clearSelectedBtnState {
    [_mouseBtn setSelected:NO];
    [_selectBtn setSelected:NO];
    [_penBtn setSelected:NO];
    [_textBtn setSelected:NO];
    [_shapeBtn setSelected:NO];
    [_eraserBtn setSelected:NO];
}

- (void)mouseDown:(NSEvent *)event {
    DrawingViewController *drawingViewController = (DrawingViewController *)[[[self view] window] contentViewController];
    [drawingViewController setTextFieldEditable:NO];//禁用文字编辑
    [drawingViewController clearSelectStatus];//清楚选中状态
    [super mouseDown:event];
}

- (IBAction)buttonAction:(id)sender {
    SAButton *button = sender;
    NSInteger btnTag = [button tag];
    NSColor *windowBackgroundColorIgnoresMouseEvent = [NSColor clearColor];//给window设置透明背景色后，鼠标穿透
    NSColor *windowBackgroundColorAcceptMouseEvent = [NSColor colorWithWhite:1.0 alpha:0.05];//给window设置非透明背景色后，鼠标接受时间
    DrawingViewController *drawingViewController = (DrawingViewController *)[[[self view] window] contentViewController];
    [drawingViewController setTextFieldEditable:NO];//禁用文字编辑
    [drawingViewController clearSelectStatus];//清楚选中状态
    switch (btnTag) {
        case ToolTypeMouse: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [[self.view window] setBackgroundColor:windowBackgroundColorIgnoresMouseEvent];
            break;
        }
        case ToolTypeSelect: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [[self.view window] setBackgroundColor:windowBackgroundColorAcceptMouseEvent];
            break;
        }
        case ToolTypePen: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [drawingViewController setDrawingType:DrawingTypeGraffiti];
            [[self.view window] setBackgroundColor:windowBackgroundColorAcceptMouseEvent];
            break;
        }
        case ToolTypeText: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [[self.view window] setBackgroundColor:windowBackgroundColorAcceptMouseEvent];
            [drawingViewController setTextFieldEditable:YES];
            break;
        }
        case ToolTypeShape: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [[self.view window] setBackgroundColor:windowBackgroundColorAcceptMouseEvent];
            [self showShapeSettingPanel:sender];
            break;
        }
        case ToolTypeColor: {
            [self showColorSettingPanel:sender];
            break;
        }
        case ToolTypeErase: {
            [self clearSelectedBtnState];
            [drawingViewController setToolType:btnTag];
            [[self.view window] setBackgroundColor:windowBackgroundColorAcceptMouseEvent];
            break;
        }
        case ToolTypeUndo: {
            [drawingViewController undo:sender];
            break;
        }
        case ToolTypeRedo: {
            [drawingViewController redo:sender];
            break;
        }
        case ToolTypeClear: {
            [drawingViewController removeAll];
            break;
        }
        case ToolTypeSave: {
            [self screenshot];
            break;
        }
            
        default:
            break;
    }
    
    [button setSelected:YES];
    [drawingViewController mouseEntered:nil];
}

- (IBAction)quitAnnotation:(id)sender {
    [NSApp terminate:nil];
}

- (IBAction)toggleToolbar:(id)sender {
    if ([self view].hidden) {
        [[self view] setHidden:NO];
        self.view.window.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.05];
        _toggleMenuItem.title = NSLocalizedString(@"Hide Toolbar", nil);
    } else {
        [[self view] setHidden:YES];
        self.view.window.backgroundColor = [NSColor clearColor];
        _toggleMenuItem.title = NSLocalizedString(@"Show Toolbar", nil);
    }
}

- (void)screenshot {
    NSRect screenRect = [self.view.window.screen frame];
    screenRect.origin.y = 0;
    CGImageRef cgImage = CGWindowListCreateImage(screenRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0]
                                                           forKey:NSImageCompressionFactor];
    _saveImageData = [rep representationUsingType:NSBitmapImageFileTypePNG properties:imageProps];
    
    if (_saveImageData) {
        [self saveScreenshot];
    }
}

- (void)saveScreenshot {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"zy-%@", strDate];
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:fileName];
    [panel setAllowedFileTypes:@[@"png"]];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setLevel:self.view.window.level + 1];
    __weak __typeof(&*self)weakSelf = self;
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSFileHandlingPanelOKButton) {
             __strong __typeof(&*self)strongSelf = weakSelf;
            if (strongSelf.saveImageData) {
                [strongSelf.saveImageData writeToURL:[panel URL] options:NSDataWritingAtomic error:nil];
            }
        }
    }];
}

- (void)showShapeSettingPanel:(NSButton *)button {
    NSColor *color = [[self.view window] backgroundColor];
    _shapeSettingPopover.contentViewController = _shapeSettingViewController;
    [_shapeSettingPopover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
    [self.view.window setBackgroundColor:[NSColor clearColor]];
    [self.view.window setBackgroundColor:color];
}

- (void)showColorSettingPanel:(NSButton *)button {
    NSColor *color = [[self.view window] backgroundColor];
    _colorSettingPopover.contentViewController = _colorSettingViewController;
    [_colorSettingPopover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
    [self.view.window setBackgroundColor:[NSColor clearColor]];
    [self.view.window setBackgroundColor:color];
}

@end
