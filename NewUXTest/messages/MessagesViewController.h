//
//  MessagesViewController.h
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagesViewControllerDelegate <NSObject>

- (void)didSelectedMessagesTabIndex:(NSInteger)index;

@end

@interface MessagesViewController : UIViewController

@property (nonatomic, assign) id<MessagesViewControllerDelegate> delegate;

@end
