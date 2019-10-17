//
//  UIView+Common.m
//  Test
//
//  Created by ccq on 2019/10/15.
//  Copyright © 2019 ccq. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

@interface UIView (CornerShadow)

@property (nonatomic, assign) BOOL lq_isSetCornerRadius; //是否是设置圆角
@property (nonatomic, assign) CGFloat lq_cornerRadius; //圆角半径
@property (nonatomic, assign) NSUInteger lq_rectCorner; //圆角边
@property (nonatomic, strong) CAShapeLayer *lq_cornerMaskLayer;; //设置圆角layer

@property (nonatomic, assign) BOOL lq_isSetShadow; //是否设置阴影
@property (nonatomic, strong) UIView *lq_shadowView; //阴影容器
@property (nonatomic, strong) UIColor *lq_shadowColor; //阴影颜色
@property (nonatomic, assign) CGSize lq_shadowOffset; //阴影偏移
@property (nonatomic, assign) CGFloat lq_shadowRadius; //阴影半径
@property (nonatomic, assign) NSInteger lq_shadowSide; //阴影边
@property (nonatomic, strong) CALayer *lq_topShadowLayer; //上边阴影
@property (nonatomic, strong) CALayer *lq_bottomShadowLayer; //下边阴影
@property (nonatomic, strong) CALayer *lq_leftShadowLayer; //左边阴影
@property (nonatomic, strong) CALayer *lq_rightShadowLayer; //右边阴影

@end

@implementation UIView (Common)

static const NSString * kLQSetCornerRadiusKey = @"kLQSetCornerRadiusKey";
static const NSString * kLQCornerRadiusKey = @"kLQCornerRadiusKey";
static const NSString * kLQRectCornerKey = @"kLQRectCornerKey";
static const NSString * kLQCornerMaskLayerKey = @"kLQCornerMaskLayerKey";

static const NSString * kLQSetShadowKey = @"kLQSetShadowKey";
static const NSString * kLQShadowViewKey = @"kLQShadowViewKey";
static const NSString * kLQShadowColorKey = @"kLQShadowColorKey";
static const NSString * kLQShadowOffsetKey = @"kLQShadowOffsetKey";
static const NSString * kLQShadowRadiusKey = @"kLQShadowRadiusKey";
static const NSString * kLQShadowSideKey = @"kLQShadowSideKey";
static const NSString * kLQTopShadowLayerKey = @"kLQTopShadowLayerKey";
static const NSString * kLQBottomShadowLayerKey = @"kLQBottomShadowLayerKey";
static const NSString * kLQLeftShadowLayerKey = @"kLQLeftShadowLayerKey";
static const NSString * kLQRightShadowLayerKey = @"kLQRightShadowLayerKey";


#pragma mark - public methods

- (void)lq_cornerRadius:(CGFloat)cornerRadius
{
    [self lq_cornerRadius:cornerRadius byRoundingCorners:UIRectCornerAllCorners];
}

- (void)lq_cornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)rectCorners
{
    self.lq_cornerRadius = cornerRadius;
    self.lq_rectCorner = rectCorners;
    self.lq_isSetCornerRadius = YES;
    
    [self swizzleMethodLayoutSubviews];
}

- (void)lq_shadow
{
    [self lq_shaodwRadius:5.0 shadowColor:[UIColor colorWithWhite:0 alpha:0.3] shadowOffset:CGSizeMake(0, 0) byShadowSide:LQShadowSideAllSides];
}

- (void)lq_horizontalShaodwRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset
{
    [self lq_shaodwRadius:shadowRadius shadowColor:shadowColor shadowOffset:shadowOffset byShadowSide:LQShadowSideLeft | LQShadowSideRight];
}

- (void)lq_verticalShaodwRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset
{
    [self lq_shaodwRadius:shadowRadius shadowColor:shadowColor shadowOffset:shadowOffset byShadowSide:LQShadowSideTop | LQShadowSideBottom];
}

- (void)lq_shaodwRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset byShadowSide:(LQShadowSide)shadowSide
{
    self.lq_isSetShadow = YES;
    self.lq_shadowRadius = shadowRadius;
    self.lq_shadowOffset = shadowOffset;
    self.lq_shadowColor = shadowColor;
    self.lq_shadowSide = shadowSide;
    
    [self swizzleMethodLayoutSubviews];
}

#pragma mark - private methods

- (void)swizzleMethodLayoutSubviews
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(lq_layoutSubviews)];
    });
}

- (void)lq_layoutSubviews
{
    [self lq_layoutSubviews];

    if (self.lq_isSetShadow) {
        [self setupShadow];
    }
    
    if (self.lq_isSetCornerRadius) {
        [self setupCornerRadius];
    }
}

- (void)setupCornerRadius
{
    if (self.lq_cornerRadius <= 0) {
        return;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.lq_rectCorner cornerRadii:CGSizeMake(self.lq_cornerRadius, self.lq_cornerRadius)];
    self.lq_cornerMaskLayer.frame = self.bounds;
    self.lq_cornerMaskLayer.path = maskPath.CGPath;
    
    if (self.lq_isSetShadow) {
        self.lq_shadowView.layer.mask = self.lq_cornerMaskLayer;
    } else {
        self.layer.mask = self.lq_cornerMaskLayer;
    }
}

- (void)setupShadow
{
    if (self.lq_shadowRadius <= 0 && self == self.lq_shadowView) {
        return;
    }
    
    self.lq_shadowView.frame = self.bounds;
    
    //上边
    if (self.lq_shadowSide & LQShadowSideTop) {
        [self setSingleSideShadowWithShadowRadius:self.lq_shadowRadius shadowColor:self.lq_shadowColor shadowOffset:self.lq_shadowOffset byShadowSide:LQShadowSideTop];
    }
    
    //左边
    if (self.lq_shadowSide & LQShadowSideLeft) {
        [self setSingleSideShadowWithShadowRadius:self.lq_shadowRadius shadowColor:self.lq_shadowColor shadowOffset:self.lq_shadowOffset byShadowSide:LQShadowSideLeft];
    }
    
    //右边
    if (self.lq_shadowSide & LQShadowSideRight) {
        [self setSingleSideShadowWithShadowRadius:self.lq_shadowRadius shadowColor:self.lq_shadowColor shadowOffset:self.lq_shadowOffset byShadowSide:LQShadowSideRight];
    }
    
    //下边
    if (self.lq_shadowSide & LQShadowSideBottom) {
        [self setSingleSideShadowWithShadowRadius:self.lq_shadowRadius shadowColor:self.lq_shadowColor shadowOffset:self.lq_shadowOffset byShadowSide:LQShadowSideBottom];
    }
}

// 绘制单边阴影
- (void)setSingleSideShadowWithShadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset byShadowSide:(LQShadowSide)shadowSide
{
    CALayer *shadowLayer = nil;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (shadowSide & LQShadowSideTop) {
        shadowLayer = self.lq_topShadowLayer;
        shadowLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.5);
        [path moveToPoint:CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5)];
        [path addLineToPoint:(CGPointMake(0, 0))];
        [path addLineToPoint:(CGPointMake(self.bounds.size.width, 0))];
    } else if (shadowSide & LQShadowSideLeft) {
        shadowLayer = self.lq_leftShadowLayer;
        shadowLayer.frame = CGRectMake(0, 0, self.frame.size.height*0.5, self.frame.size.height);
        [path moveToPoint:CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5)];
        [path addLineToPoint:(CGPointMake(0, 0))];
        [path addLineToPoint:(CGPointMake(0, self.bounds.size.height))];
    } else if (shadowSide & LQShadowSideRight) {
        shadowLayer = self.lq_rightShadowLayer;
        shadowLayer.frame = CGRectMake(self.frame.size.width*0.5, 0, self.frame.size.width*0.5, self.frame.size.height);
        [path moveToPoint:CGPointMake(0, self.bounds.size.height*0.5)];
        [path addLineToPoint:(CGPointMake(self.frame.size.width*0.5, 0))];
        [path addLineToPoint:(CGPointMake(self.frame.size.width*0.5, self.bounds.size.height))];
    } else if (shadowSide & LQShadowSideBottom) {
        shadowLayer = self.lq_bottomShadowLayer;
        shadowLayer.frame = CGRectMake(0, self.frame.size.height*0.5, self.frame.size.width, self.frame.size.height*0.5);
        [path moveToPoint:CGPointMake(self.bounds.size.width*0.5, 0)];
        [path addLineToPoint:(CGPointMake(0, self.bounds.size.height*0.5))];
        [path addLineToPoint:(CGPointMake(self.bounds.size.width, self.bounds.size.height*0.5))];
    }
    
    [self.layer insertSublayer:shadowLayer atIndex:0];
    
    shadowLayer.masksToBounds = NO;
    
    CGFloat components[4];
    [self getRGBAComponents:components forColor:self.lq_shadowColor];
    
    shadowLayer.shadowColor   = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:1.0].CGColor;
    shadowLayer.shadowOpacity = components[3];
    shadowLayer.shadowRadius  = self.lq_shadowRadius;
    shadowLayer.shadowOffset  = CGSizeMake(0, 0);
    shadowLayer.shadowPath    = path.CGPath;
}

- (void)getRGBAComponents:(CGFloat [4])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4] = {0};
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGFloat a = resultingPixel[3] / 255.0;
    CGFloat unpremultiply = (a != 0.0) ? 1.0 / a / 255.0 : 0.0;
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] * unpremultiply;
    }
    components[3] = a;
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel
{
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

#pragma mark - getters and setters

- (BOOL)lq_isSetCornerRadius
{
    return [objc_getAssociatedObject(self, &kLQSetCornerRadiusKey) boolValue];
}

- (void)setLq_isSetCornerRadius:(BOOL)lq_isSetCornerRadius
{
    objc_setAssociatedObject(self, &kLQSetCornerRadiusKey, [NSNumber numberWithBool:lq_isSetCornerRadius], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)lq_cornerRadius
{
    return [objc_getAssociatedObject(self, &kLQCornerRadiusKey) floatValue];
}

- (void)setLq_cornerRadius:(CGFloat)lq_cornerRadius
{
    objc_setAssociatedObject(self, &kLQCornerRadiusKey, [NSNumber numberWithFloat:lq_cornerRadius], OBJC_ASSOCIATION_RETAIN);
}

- (NSUInteger)lq_rectCorner
{
    return [objc_getAssociatedObject(self, &kLQRectCornerKey) unsignedIntegerValue];
}

- (void)setLq_rectCorner:(NSUInteger)lq_rectCorner
{
    objc_setAssociatedObject(self, &kLQRectCornerKey, [NSNumber numberWithUnsignedInteger:lq_rectCorner], OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)lq_cornerMaskLayer
{
    CAShapeLayer *layer = objc_getAssociatedObject(self, &kLQCornerMaskLayerKey);
    if (layer == nil) {
        layer = [[CAShapeLayer alloc] init];
        self.lq_cornerMaskLayer = layer;
    }
    
    return layer;
}

- (void)setLq_cornerMaskLayer:(CAShapeLayer *)lq_cornerMaskLayer
{
    objc_setAssociatedObject(self, &kLQCornerMaskLayerKey, lq_cornerMaskLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lq_isSetShadow
{
    return [objc_getAssociatedObject(self, &kLQSetShadowKey) boolValue];
}

- (void)setLq_isSetShadow:(BOOL)lq_isSetShadow
{
    objc_setAssociatedObject(self, &kLQSetShadowKey, [NSNumber numberWithBool:lq_isSetShadow], OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)lq_shadowView
{
    UIView *view = objc_getAssociatedObject(self, &kLQShadowViewKey);
    if (view == nil) {
        view = [[UIView alloc] init];
        view.clipsToBounds = YES;
        view.backgroundColor = self.backgroundColor;
        [self insertSubview:view atIndex:0];
        
        self.backgroundColor = [UIColor clearColor];
        self.lq_shadowView = view;
    }
    
    return view;
}

- (void)setLq_shadowView:(UIView *)lq_shadowView
{
    objc_setAssociatedObject(self, &kLQShadowViewKey, lq_shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lq_shadowColor
{
    return objc_getAssociatedObject(self, &kLQShadowColorKey);
}

- (void)setLq_shadowColor:(UIColor *)lq_shadowColor
{
    objc_setAssociatedObject(self, &kLQShadowColorKey, lq_shadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)lq_shadowOffset
{
    return [objc_getAssociatedObject(self, &kLQShadowOffsetKey) CGSizeValue];
}

- (void)setLq_shadowOffset:(CGSize)lq_shadowOffset
{
    objc_setAssociatedObject(self, &kLQShadowColorKey, [NSNumber valueWithCGSize:lq_shadowOffset], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)lq_shadowRadius
{
    return [objc_getAssociatedObject(self, &kLQShadowRadiusKey) floatValue];
}

- (void)setLq_shadowRadius:(CGFloat)lq_shadowRadius
{
    objc_setAssociatedObject(self, &kLQShadowRadiusKey, [NSNumber numberWithFloat:lq_shadowRadius], OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)lq_shadowSide
{
    return [objc_getAssociatedObject(self, &kLQShadowSideKey) integerValue];
}

- (void)setLq_shadowSide:(NSInteger)lq_shadowSide
{
    objc_setAssociatedObject(self, &kLQShadowSideKey, [NSNumber numberWithInteger:lq_shadowSide], OBJC_ASSOCIATION_RETAIN);
}

- (CALayer *)lq_topShadowLayer
{
    CALayer * layer = objc_getAssociatedObject(self, &kLQTopShadowLayerKey);
    if (layer == nil) {
        layer = [[CALayer alloc] init];
        self.lq_topShadowLayer = layer;
    }
    
    return layer;
}

- (void)setLq_topShadowLayer:(CALayer *)lq_topShadowLayer
{
    objc_setAssociatedObject(self, &kLQTopShadowLayerKey, lq_topShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)lq_bottomShadowLayer
{
    CALayer * layer = objc_getAssociatedObject(self, &kLQBottomShadowLayerKey);
    if (layer == nil) {
        layer = [[CALayer alloc] init];
        self.lq_bottomShadowLayer = layer;
    }
    
    return layer;
}

- (void)setLq_bottomShadowLayer:(CALayer *)lq_bottomShadowLayer
{
    objc_setAssociatedObject(self, &kLQBottomShadowLayerKey, lq_bottomShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)lq_leftShadowLayer
{
    CALayer * layer = objc_getAssociatedObject(self, &kLQLeftShadowLayerKey);
    if (layer == nil) {
        layer = [[CALayer alloc] init];
        self.lq_leftShadowLayer = layer;
    }
    
    return layer;
}

- (void)setLq_leftShadowLayer:(CALayer *)lq_leftShadowLayer
{
    objc_setAssociatedObject(self, &kLQLeftShadowLayerKey, lq_leftShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)lq_rightShadowLayer
{
    CALayer * layer = objc_getAssociatedObject(self, &kLQRightShadowLayerKey);
    if (layer == nil) {
        layer = [[CALayer alloc] init];
        self.lq_rightShadowLayer = layer;
    }
    
    return layer;
}

- (void)setLq_rightShadowLayer:(CALayer *)lq_rightShadowLayer
{
    objc_setAssociatedObject(self, &kLQRightShadowLayerKey, lq_rightShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
