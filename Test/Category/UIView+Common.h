//
//  UIView+Common.h
//  Test
//
//  Created by ccq on 2019/10/15.
//  Copyright © 2019 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LQShadowSide) {
    LQShadowSideTop       = 1 << 0,
    LQShadowSideBottom    = 1 << 1,
    LQShadowSideLeft      = 1 << 2,
    LQShadowSideRight     = 1 << 3,
    LQShadowSideAllSides  = ~0UL
};

@interface UIView (Common)

/**
设置指定角的圆角

 @param cornerRadius 圆角半径
 @param rectCorners 圆角边
 */
- (void)lq_cornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)rectCorners;

/**
设置四周圆角

 @param cornerRadius 圆角半径
 */
- (void)lq_cornerRadius:(CGFloat)cornerRadius;

/**
 设置阴影，默认圆角为5，阴影颜色为0.3纯黑色
 */
- (void)lq_shadow;

/**
 * 设置垂直方向的阴影
 *
 * @param shadowRadius   阴影半径
 * @param shadowColor    阴影颜色
 * @param shadowOffset   阴影偏移
 */
- (void)lq_verticalShaodwRadius:(CGFloat)shadowRadius
                    shadowColor:(UIColor *)shadowColor
                   shadowOffset:(CGSize)shadowOffset;
/**
 * 设置水平方向的阴影
 *
 * @param shadowRadius   阴影半径
 * @param shadowColor    阴影颜色
 * @param shadowOffset   阴影偏移
 */
- (void)lq_horizontalShaodwRadius:(CGFloat)shadowRadius
                      shadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset;
/**
 * 设置阴影
 *
 * @param shadowRadius   阴影半径
 * @param shadowColor    阴影颜色
 * @param shadowOffset   阴影偏移
 * @param shadowSide     阴影边
 */
- (void)lq_shaodwRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
           shadowOffset:(CGSize)shadowOffset
           byShadowSide:(LQShadowSide)shadowSide;

@end

NS_ASSUME_NONNULL_END
