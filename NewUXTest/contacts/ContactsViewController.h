//
//  ContactsViewController.h
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsViewControllerDelegate <NSObject>

- (void)didSelectedContactsTabIndex:(NSInteger)index;

@end

@interface ContactsViewController : UIViewController

@property (nonatomic, assign) id<ContactsViewControllerDelegate> delegate;

@end
