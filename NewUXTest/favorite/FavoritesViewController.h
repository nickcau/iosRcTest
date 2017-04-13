//
//  FavoritesViewController.h
//  Proto B.1.4
//
//  Created by lamsion.chen on 6/5/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FavoritesViewControllerDelegate <NSObject>

- (void)didSelectedFavoritesTabIndex:(NSInteger)index;

@end

@interface FavoritesViewController : UIViewController

@property (nonatomic, assign) id<FavoritesViewControllerDelegate> delegate;

@end
