//
//  UIScrollView+XHVisibleCenterScroll.m
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-9. Updated by lamsion.chen on 22/05/14.
//  Copyright (c) 2014年 曾宪华
//

#import "UIScrollView+XHVisibleCenterScroll.h"

@implementation UIScrollView (XHVisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width/2.0 - self.frame.size.width/2.0,
                                     visibleRect.origin.y + visibleRect.size.height/2.0 - self.frame.size.height/2.0,
                                     self.frame.size.width,
                                     self.frame.size.height);
    [self scrollRectToVisible:centeredRect
                     animated:animated];
}

@end
