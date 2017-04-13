//
//  DocumentsViewController.h
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol DocumentsViewControllerDelegate <NSObject>

- (void)didSelectedDocumentsTabIndex:(NSInteger)index;

@end

@interface DocumentsViewController : UIViewController

@property (nonatomic, assign) id<DocumentsViewControllerDelegate> delegate;

@end
