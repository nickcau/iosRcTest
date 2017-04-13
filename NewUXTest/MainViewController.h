//
//  MainViewController.h
//  RC A
//
//  Created by lamsion.chen on 7/14/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMenu/RCMenu.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate,RCMenuDelegate>
{
@private
    NSMutableArray *_viewArrayOfPages;
}
@property (strong, nonatomic) RCMenu *menu;
@property (strong, nonatomic) UIView *blurView;

@end
