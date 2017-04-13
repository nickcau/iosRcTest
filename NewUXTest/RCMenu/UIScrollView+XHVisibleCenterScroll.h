//
//  UIScrollView+XHVisibleCenterScroll.h
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-9. Updated by lamsion.chen on 22/05/14.
//  Copyright (c) 2014年 曾宪华
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XHVisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated;

@end
