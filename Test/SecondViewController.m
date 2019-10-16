//
//  SecondViewController.m
//  Test
//
//  Created by ccq on 2019/10/16.
//  Copyright © 2019 ccq. All rights reserved.
//

#import "SecondViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>

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
