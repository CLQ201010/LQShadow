//
//  ViewController.m
//  Test
//
//  Created by ccq on 2019/9/4.
//  Copyright © 2019 ccq. All rights reserved.
//

#import <SDAutoLayout/SDAutoLayout.h>
#import "ViewController.h"
#import "UIView+Common.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

#pragma mark - life cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setupUI];
    [self setupShadows];
    [self setupCorners];
}

#pragma mark - events

- (void)btnClick
{
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.bgView lq_cornerRadius:8];
    [self.imgView lq_cornerRadius:10 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight];
}

- (void)setupShadows
{
    [self.bgView lq_shadow];
    [self.imgView lq_verticalShaodwRadius:10 shadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] shadowOffset:CGSizeMake(0, 1)];
}

#pragma mark - getters and setters

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
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
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn setTitle:@"Second" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn;
}

@end
