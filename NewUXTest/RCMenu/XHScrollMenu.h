//
//  XHScrollMenu.h
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-8.
//  Copyright (c) 2014年 曾宪华
//

#import <UIKit/UIKit.h>
#import "XHIndicatorView.h"
#import "XHMenu.h"
#import "XHMenuButton.h"



@class XHScrollMenu;

@protocol XHScrollMenuDelegate <NSObject>

- (void)scrollMenuDidSelected:(XHScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex;
- (void)scrollMenuDidManagerSelected:(XHScrollMenu *)scrollMenu;
- (void)menuButtonClicked:(NSUInteger)index;

@end

@interface XHScrollMenu : UIViewController

@property (nonatomic, assign) id <XHScrollMenuDelegate> delegate;

// UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XHIndicatorView *indicatorView;

// DataSource
@property (nonatomic, strong) NSArray *menus;

// Badge number

@property int badgeNum;

// select
@property (nonatomic, assign) NSUInteger selectedIndex; // default is 0


- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate;

- (CGRect)rectForSelectedItemAtIndex:(NSUInteger)index;

- (XHMenuButton *)menuButtonAtIndex:(NSUInteger)index;

- (void)scrollTo:(NSUInteger)index;

// reload dataSource
- (void)reloadData;

@end
