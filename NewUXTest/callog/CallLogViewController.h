//
//  CallLogViewController.h
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CallLogViewControllerDelegate <NSObject>

- (void)didSelectedCallLogTabIndex:(NSInteger)index;

@end

@interface CallLogViewController : UIViewController

@property (nonatomic, assign) id<CallLogViewControllerDelegate> delegate;

@end

