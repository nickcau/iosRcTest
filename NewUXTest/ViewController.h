//
//  ViewController.h
//  NewUXTest
//
//  Created by 高友健 on 2017/4/8.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagesViewControllerDelegate <NSObject>

- (void)didSelectedMessagesTabIndex:(NSInteger)index;

@end

@interface ViewController : UIViewController

@property (nonatomic, assign) id<MessagesViewControllerDelegate> delegate;

@end

