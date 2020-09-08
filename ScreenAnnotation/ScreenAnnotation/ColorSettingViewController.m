//
//  ColorSettingViewController.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "ColorSettingViewController.h"
#import "SAButton.h"

@interface ColorSettingViewController ()

@property (nonatomic, weak) IBOutlet SAButton *color1Btn;
@property (nonatomic, weak) IBOutlet SAButton *color2Btn;
@property (nonatomic, weak) IBOutlet SAButton *color3Btn;
@property (nonatomic, weak) IBOutlet SAButton *color4Btn;
@property (nonatomic, weak) IBOutlet SAButton *color5Btn;
@property (nonatomic, weak) IBOutlet SAButton *color6Btn;
@property (nonatomic, weak) IBOutlet SAButton *color7Btn;
@property (nonatomic, weak) IBOutlet SAButton *color8Btn;
@property (nonatomic, weak) IBOutlet SAButton *color9Btn;
@property (nonatomic, weak) IBOutlet SAButton *color10Btn;
@property (nonatomic, weak) IBOutlet SAButton *color11Btn;
@property (nonatomic, weak) IBOutlet SAButton *color12Btn;
@property (nonatomic, weak) IBOutlet SAButton *color13Btn;
@property (nonatomic, weak) IBOutlet SAButton *color14Btn;
@property (nonatomic, weak) IBOutlet SAButton *color15Btn;
@property (nonatomic, weak) IBOutlet SAButton *color16Btn;

@property (nonatomic, weak) IBOutlet SAButton *lineWidth1Btn;
@property (nonatomic, weak) IBOutlet SAButton *lineWidth2Btn;
@property (nonatomic, weak) IBOutlet SAButton *lineWidth3Btn;
@property (nonatomic, weak) IBOutlet SAButton *lineWidth4Btn;
@property (nonatomic, weak) IBOutlet SAButton *lineWidth5Btn;

@property (nonatomic, strong) NSDictionary *colorData;
@property (nonatomic, strong) NSDictionary *lineWithData;

@property (nonatomic, strong) NSFont *currentFont;
@property (nonatomic, strong) NSColor *currentColor;
@property (nonatomic, assign) CGFloat currentColorAlpha;
@property (nonatomic, assign) NSInteger currentLineWidth;
@property (nonatomic, strong) NSImage *currentColorIconImage;
@property (nonatomic, strong) NSImage *currentColorIconAlterImage;

@property (nonatomic, weak) IBOutlet NSSlider *colorAlphaSlider;
@property (nonatomic, weak) IBOutlet NSSlider *lineWidthSlider;
@property (nonatomic, weak) IBOutlet NSSlider *fontSizeSlider;

- (IBAction)colorAlphaChange:(id)sender;
- (IBAction)lineWidthChange:(id)sender;
- (IBAction)fontSizeChange:(id)sender;

- (IBAction)colorButtonAction:(id)sender;
- (IBAction)lineWidthButtonAction:(id)sender;

@end

@implementation ColorSettingViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _colorData = @{
            @"color1":[NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0],
            @"color2":[NSColor colorWithRed:255.0/ 255.0 green:138.0 / 255.0 blue:0.0 alpha:1.0],
            @"color3":[NSColor colorWithRed:255.0/ 255.0 green:56.0 / 255.0 blue:199.0 / 255.0 alpha:1.0],
            @"color4":[NSColor colorWithRed:101.0/ 255.0 green:72.0 / 255.0 blue:246.0 / 255.0 alpha:1.0],
            @"color5":[NSColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0],
            @"color6":[NSColor colorWithRed:81.0/ 255.0 green:216.0 / 255.0 blue:235.0 / 255.0 alpha:1.0],
            @"color7":[NSColor colorWithRed:73.0/ 255.0 green:214.0 / 255.0 blue:30.0 / 255.0 alpha:1.0],
            @"color8":[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
            @"color9":[NSColor colorWithRed:128.0/ 255.0 green:128.0 / 255.0 blue:128.0 / 255.0 alpha:1.0],
            @"color10":[NSColor colorWithRed:0.0 green:26.0 / 255.0 blue:245.0 / 255.0 alpha:1.0],
            @"color11":[NSColor colorWithRed:9.0/ 255.0 green:34.0 / 255.0 blue:84.0 / 255.0 alpha:1.0],
            @"color12":[NSColor colorWithRed:149.0/ 255.0 green:149.0 / 255.0 blue:149.0 / 255.0 alpha:1.0],
            @"color13":[NSColor colorWithRed:152.0/ 255.0 green:202.0 / 255.0 blue:62.0 / 255.0 alpha:1.0],
            @"color14":[NSColor colorWithRed:117.0/ 255.0 green:250.0 / 255.0 blue:76.0 / 255.0 alpha:1.0],
            @"color15":[NSColor colorWithRed:48.0/ 255.0 green:112.0 / 255.0 blue:60.0 / 255.0 alpha:1.0],
            @"color16":[NSColor colorWithRed:255.0/ 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
        };
        _lineWithData = @{
            @"lineWidth1":[NSNumber numberWithInteger:3],
            @"lineWidth2":[NSNumber numberWithInteger:5],
            @"lineWidth3":[NSNumber numberWithInteger:9],
            @"lineWidth4":[NSNumber numberWithInteger:12],
            @"lineWidth5":[NSNumber numberWithInteger:15],
        };
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor colorWithRed:51.0 / 255.0 green:57.0 / 255.0 blue:63.0 / 255.0 alpha:1.0] CGColor];//背景色
    
    [_color1Btn setIdentifier:@"color1"];
    [_color1Btn setCanSelected:YES];
    [_color2Btn setIdentifier:@"color2"];
    [_color2Btn setCanSelected:YES];
    [_color3Btn setIdentifier:@"color3"];
    [_color3Btn setCanSelected:YES];
    [_color4Btn setIdentifier:@"color4"];
    [_color4Btn setCanSelected:YES];
    [_color5Btn setIdentifier:@"color5"];
    [_color5Btn setCanSelected:YES];
    [_color6Btn setIdentifier:@"color6"];
    [_color6Btn setCanSelected:YES];
    [_color7Btn setIdentifier:@"color7"];
    [_color7Btn setCanSelected:YES];
    [_color8Btn setIdentifier:@"color8"];
    [_color8Btn setCanSelected:YES];
    [_color9Btn setIdentifier:@"color9"];
    [_color9Btn setCanSelected:YES];
    [_color10Btn setIdentifier:@"color10"];
    [_color11Btn setIdentifier:@"color11"];
    [_color12Btn setIdentifier:@"color12"];
    [_color13Btn setIdentifier:@"color13"];
    [_color14Btn setIdentifier:@"color14"];
    [_color15Btn setIdentifier:@"color15"];
    [_color16Btn setIdentifier:@"color16"];
    
    [_lineWidth1Btn setIdentifier:@"lineWidth1"];
    [_lineWidth1Btn setCanSelected:YES];
    [_lineWidth2Btn setIdentifier:@"lineWidth2"];
    [_lineWidth2Btn setCanSelected:YES];
    [_lineWidth3Btn setIdentifier:@"lineWidth3"];
    [_lineWidth3Btn setCanSelected:YES];
    [_lineWidth4Btn setIdentifier:@"lineWidth4"];
    [_lineWidth4Btn setCanSelected:YES];
    [_lineWidth5Btn setIdentifier:@"lineWidth5"];
    [_lineWidth5Btn setCanSelected:YES];
    
    _currentColorAlpha = 1.0;//_colorAlphaSlider.floatValue;
    _currentColorIconAlterImage = _color1Btn.alternateImage;
    _currentColorIconImage = _color1Btn.image;
    _currentLineWidth = [[_lineWithData objectForKey:_lineWidth2Btn.identifier] integerValue];//_lineWidthSlider.integerValue;
//    _currentFont = [NSFont fontWithName:@"HelveticaNeue" size:_fontSizeSlider.integerValue];
    _currentFont = [NSFont fontWithName:@"HelveticaNeue" size:_currentLineWidth * 5];
    _currentColor = [_colorData objectForKey:_color1Btn.identifier];
    
    [_color1Btn setSelected:YES];
    [_lineWidth2Btn setSelected:YES];
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconAlterImage, _currentColor, _currentFont, _currentLineWidth);
}

- (void)clearColorButtonSelectStatus {
    [_color1Btn setSelected:NO];
    [_color2Btn setSelected:NO];
    [_color3Btn setSelected:NO];
    [_color4Btn setSelected:NO];
    [_color5Btn setSelected:NO];
    [_color6Btn setSelected:NO];
    [_color7Btn setSelected:NO];
    [_color8Btn setSelected:NO];
    [_color9Btn setSelected:NO];
}

- (void)clearLineWidthButtonSelectStatus {
    [_lineWidth1Btn setSelected:NO];
    [_lineWidth2Btn setSelected:NO];
    [_lineWidth3Btn setSelected:NO];
    [_lineWidth4Btn setSelected:NO];
    [_lineWidth5Btn setSelected:NO];
}

- (IBAction)colorButtonAction:(id)sender {
    [self clearColorButtonSelectStatus];
    
    SAButton *button = (SAButton *)sender;
    [button setSelected:YES];
    _currentColorIconImage = button.image;
    _currentColorIconAlterImage = button.alternateImage;
    _currentColor = [[_colorData objectForKey:button.identifier] colorWithAlphaComponent:_currentColorAlpha];
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconImage, _currentColor, _currentFont, _currentLineWidth);
}

- (IBAction)lineWidthButtonAction:(id)sender {
    [self clearLineWidthButtonSelectStatus];
    
    SAButton *button = (SAButton *)sender;
    [button setSelected:YES];
    _currentLineWidth = [[_lineWithData objectForKey:button.identifier] integerValue];
    _currentFont = [NSFont fontWithName:@"HelveticaNeue" size:_currentLineWidth * 5];
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconImage, _currentColor, _currentFont, _currentLineWidth);
}

- (IBAction)colorAlphaChange:(id)sender {
    NSSlider *slider = (NSSlider *)sender;
    CGFloat value = [slider floatValue];
    _currentColorAlpha = value;
    _currentColor = [_currentColor colorWithAlphaComponent:value];
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconImage, _currentColor, _currentFont, _currentLineWidth);
}

- (IBAction)lineWidthChange:(id)sender {
    NSSlider *slider = (NSSlider *)sender;
    NSInteger value = [slider integerValue];
    _currentLineWidth = value;
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconImage, _currentColor, _currentFont, _currentLineWidth);
}

- (IBAction)fontSizeChange:(id)sender {
    NSSlider *slider = (NSSlider *)sender;
    NSInteger value = [slider integerValue];
    _currentFont = [NSFont fontWithName:@"HelveticaNeue" size:value];
    
    _settingsDataBlock(_currentColorIconImage, _currentColorIconImage, _currentColor, _currentFont, _currentLineWidth);
}

@end
