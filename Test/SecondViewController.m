//
//  SecondViewController.m
//  Test
//
//  Created by ccq on 2019/10/16.
//  Copyright © 2019 ccq. All rights reserved.
//

#import "SecondViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIView+Common.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation SecondViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupCorners];
    [self setupShadows];
}

#pragma mark - private methods

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.btn];
    [self.bgView addSubview:self.imgView];
    
    [self setupAutoLayout];
}

- (void)setupAutoLayout
{
    self.bgView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(200)
    .heightIs(200);
    
    self.btn.sd_layout
    .leftSpaceToView(self.bgView, 16)
    .topSpaceToView(self.bgView, 16)
    .widthIs(80)
    .heightIs(40);
    
    self.imgView.sd_layout
    .leftEqualToView(self.btn)
    .topSpaceToView(self.btn, 25)
    .widthIs(100)
    .heightIs(80);
}

- (void)setupCorners
{
    [self.bgView lq_cornerRadius:10 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [self.imgView lq_cornerRadius:10 byRoundingCorners:UIRectCornerTopLeft  | UIRectCornerBottomRight];
}

- (void)setupShadows
{
    [self.bgView lq_horizontalShaodwRadius:10 shadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] shadowOffset:CGSizeMake(0, 1)];
    
    [self.imgView lq_verticalShaodwRadius:10 shadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] shadowOffset:CGSizeMake(0, 1)];
}

#pragma mark - getters and setters

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor redColor];
    }
    
    return _bgView;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor blueColor];
    }
    
    return _imgView;
}

- (UIButton *)btn
{
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
        _btn.backgroundColor = [UIColor orangeColor];
    }
    
    return _btn;
}

@end
