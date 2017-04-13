//
//  RCMenuItem.h
//  RCMenu
//
//  Created by lamsion.chen on 4/9/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCMenuItemDelegate;

@interface RCMenuItem : UIImageView
{
    UIImageView *_contentImageView;
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _nearPoint; // near
    CGPoint _farPoint; // far
    
    id<RCMenuItemDelegate> __weak _delegate;
}

@property (nonatomic, strong, readonly) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *itemBadge;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;


@property (nonatomic, weak) id<RCMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg
              title:(NSString *)ctitle;


@end

@protocol RCMenuItemDelegate <NSObject>
- (void)RCMenuItemTouchesBegan:(RCMenuItem *)item;
- (void)AwesomeMenuItemTouchesEnd:(RCMenuItem *)item;
@end