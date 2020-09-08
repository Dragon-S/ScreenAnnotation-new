//
//  ShapeSettingViewController.m
//  ScreenAnnotation
//
//  Created by longlong.shi on 2020/4/15.
//  Copyright © 2020 longlong.shi. All rights reserved.
//

#import "ShapeSettingViewController.h"
#import "SAButton.h"
#import "SATypeDefine.h"

@interface ShapeSettingViewController ()

@property (nonatomic, weak) IBOutlet SAButton *lineBtn;
@property (nonatomic, weak) IBOutlet SAButton *rectangleBtn;
@property (nonatomic, weak) IBOutlet SAButton *ovalBtn;
@property (nonatomic, weak) IBOutlet SAButton *diamondBtn;
@property (nonatomic, weak) IBOutlet SAButton *arrowBtn;
@property (nonatomic, weak) IBOutlet SAButton *correctBtn;
@property (nonatomic, weak) IBOutlet SAButton *errorBtn;
@property (nonatomic, weak) IBOutlet SAButton *heartBtn;
@property (nonatomic, weak) IBOutlet SAButton *questionBtn;

- (IBAction)buttonAction:(id)sender;

@end

@implementation ShapeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [_lineBtn setTag:DrawingTypeLine];
    [_rectangleBtn setTag:DrawingTypeRect];
    [_ovalBtn setTag:DrawingTypeOval];
    [_diamondBtn setTag:DrawingTypeRhombus];
    [_arrowBtn setTag:DrawingTypeArrow];
    [_correctBtn setTag:DrawingTypeCorrectMark];
    [_errorBtn setTag:DrawingTypeErrorMark];
    [_heartBtn setTag:DrawingTypeHeartMark];
    [_questionBtn setTag:DrawingTypeQuestionMark];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor colorWithRed:51.0 / 255.0 green:57.0 / 255.0 blue:63.0 / 255.0 alpha:1.0] CGColor];//背景色

    [_lineBtn setCanSelected:YES];
    [_rectangleBtn setCanSelected:YES];
    [_ovalBtn setCanSelected:YES];
    [_arrowBtn setCanSelected:YES];
    [_correctBtn setCanSelected:YES];
    [_errorBtn setCanSelected:YES];
    [_heartBtn setCanSelected:YES];
    [_questionBtn setCanSelected:YES];

}

- (void)clearButtonSelectStatus {
    [_lineBtn setSelected:NO];
    [_rectangleBtn setSelected:NO];
    [_ovalBtn setSelected:NO];
    [_arrowBtn setSelected:NO];
    [_correctBtn setSelected:NO];
    [_errorBtn setSelected:NO];
    [_heartBtn setSelected:NO];
    [_questionBtn setSelected:NO];
}

- (IBAction)buttonAction:(id)sender {
    [self clearButtonSelectStatus];
    
    SAButton *button = sender;
    [button setSelected:YES];
    NSInteger btnTag = [button tag];
    _drawingTypeBlock(button.image, button.alternateImage, btnTag);
}

@end
