//
//  XHMenu.h
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-8.Updated by lamsion.chen on 22/05/14.
//  Copyright (c) 2014年 曾宪华
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XHMenu : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *titleHighlightedColor;

@end
