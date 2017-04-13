//
//  RCMenu.h
//  RCMenu
//
//  Created by lamsion.chen on 4/9/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMenuItem.h"
#import "RCOverlayWindow.h"

@protocol RCMenuDelegate;


@interface RCMenu : UIView <RCMenuItemDelegate>

@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic, getter = isExpanding) BOOL expanding;
@property (nonatomic, weak) id<RCMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL startRotate;
@property (nonatomic, strong) UIView *overlayWindow;


- (id)initWithFrame:(CGRect)frame startItem:(RCMenuItem*)startItem optionMenus:(NSArray *)aMenusArray;

@end

@protocol RCMenuDelegate <NSObject>
- (void)rcMenu:(RCMenu *)menu didSelectIndex:(NSInteger)idx;
- (void)startOpen;
- (void)startClose;
@optional
- (void)rcMenuDidFinishAnimationClose:(RCMenu *)menu;
- (void)rcMenuDidFinishAnimationOpen:(RCMenu *)menu;
@end