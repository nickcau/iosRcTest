//
//  RCColor.h
//  NewUXTest
//
//  Created by 高友健 on 2017/4/12.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface RCColor : NSObject
+ (UIColor *)RCBlue:(CGFloat) opacity;
+ (UIColor *)RCOrange:(CGFloat) opacity;
+ (UIColor *)RCTableHighLight:(CGFloat) opacity;
+ (UIColor *)RCTableGray:(CGFloat) opacity;
+ (UIColor *)RCBadgeRed:(CGFloat) opacity;
+ (CGColorRef)RCColorRefGray:(CGFloat)opacity;
+ (CGColorRef)RCColorRefWhite:(CGFloat)opacity;
+ (UIColor *)RCColorEditGray:(CGFloat)opacity;
+ (UIColor *)RCColorEditBorder:(CGFloat)opacity;
+ (UIColor *)RCColorEditLabel:(CGFloat)opacity;
+ (UIColor *)RCColorTableSaperator:(CGFloat)opacity;
+ (UIColor *)RCTitleNormal:(CGFloat) opacity;
+ (UIColor *)RCTabBarBG:(CGFloat) opacity;
+ (CGColorRef) RCBorderBlue:(CGFloat)opacity;
+ (UIImage *) imageWithView:(UIView *)view;
@end
