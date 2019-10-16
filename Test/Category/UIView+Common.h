//
//  UIView+Common.h
//  Test
//
//  Created by ccq on 2019/10/15.
//  Copyright © 2019 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@end

NS_ASSUME_NONNULL_END
