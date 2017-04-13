//
//  RCColor.m
//  NewUXTest
//
//  Created by 高友健 on 2017/4/12.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import "RCColor.h"

@implementation RCColor

+ (UIColor *) RCBlue:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)6/255 green:(CGFloat)132/255 blue:(CGFloat)189/255 alpha:opacity]);
}

+ (UIColor *) RCOrange:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)136/255 blue:(CGFloat)0/255 alpha:opacity]);
}

+ (UIColor *) RCTableHighLight:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)237/255 green:(CGFloat)245/255 blue:(CGFloat)249/255 alpha:opacity]);
}

+ (UIColor *) RCTableGray:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)179/255 green:(CGFloat)179/255 blue:(CGFloat)179/255 alpha:opacity]);
}

+(CGColorRef) RCColorRefGray:(CGFloat)opacity{
    return [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:opacity] CGColor] ;
}

+(CGColorRef) RCColorRefWhite:(CGFloat)opacity{
    return [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:opacity] CGColor] ;
}

+(CGColorRef) RCBorderBlue:(CGFloat)opacity{
    return [[UIColor colorWithRed:6.0/255.0 green:132.0/255.0 blue:189.0/255.0 alpha:opacity] CGColor] ;
}

+(UIColor *) RCColorEditGray:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)245/255 blue:(CGFloat)245/255 alpha:opacity]);
}

+(UIColor *) RCColorEditBorder:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)178/255 green:(CGFloat)178/255 blue:(CGFloat)178/255 alpha:opacity]);
}

+(UIColor *) RCColorEditLabel:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)184/255 green:(CGFloat)184/255 blue:(CGFloat)184/255 alpha:opacity]);
}

+(UIColor *) RCColorTableSaperator:(CGFloat)opacity{
    return ([UIColor colorWithRed:(CGFloat)239/255 green:(CGFloat)239/255 blue:(CGFloat)244/255 alpha:opacity]);
}

+ (UIColor *)RCBadgeRed:(CGFloat) opacity{
    return ([UIColor colorWithRed:(CGFloat)223/255 green:(CGFloat)14/255 blue:(CGFloat)14/255 alpha:opacity]);
}

+ (UIColor *)RCTitleNormal:(CGFloat) opacity{
    return ([UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)153/255 blue:(CGFloat)153/255 alpha:opacity]);
}
+ (UIColor *)RCTabBarBG:(CGFloat) opacity{
    return ([UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:opacity]);
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
