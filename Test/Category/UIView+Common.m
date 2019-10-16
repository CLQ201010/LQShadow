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

@end

@implementation UIView (Common)

static const NSString * kLQSetCornerRadiusKey = @"kLQSetCornerRadiusKey";
static const NSString * kLQCornerRadiusKey = @"kLQCornerRadiusKey";
static const NSString * kLQRectCornerKey = @"kLQRectCornerKey";
static const NSString * kLQCornerMaskLayerKey = @"kLQCornerMaskLayerKey";
static const NSString * kLQSetShadowKey = @"kLQSetShadowKey";

#pragma mark - public methods

- (void)lq_cornerRadius:(CGFloat)cornerRadius
{
    self.lq_cornerRadius = cornerRadius;
    self.lq_rectCorner = UIRectCornerAllCorners;
    self.lq_isSetCornerRadius = YES;
    
    [self swizzleMethodLayoutSubviews];
}

- (void)lq_cornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)rectCorners
{
    self.lq_cornerRadius = cornerRadius;
    self.lq_rectCorner = rectCorners;
    self.lq_isSetCornerRadius = YES;
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
    self.layer.mask = self.lq_cornerMaskLayer;
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
    
    if (lq_isSetCornerRadius) {
        self.lq_cornerMaskLayer = [[CAShapeLayer alloc] init];
    } else {
        self.lq_cornerMaskLayer = nil;
    }
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
    return objc_getAssociatedObject(self, &kLQCornerMaskLayerKey);
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

@end
