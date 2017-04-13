//
//  MenuSkypeViewController.h
//  MenuSkype
//
//  Created by Charles-Hubert Basuiau on 01/07/2014.
//  Copyright (c) 2014 Charles-Hubert Basuiau. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_HEIGHT 49.0
#define FONT_SIZE   10.0
#define MARGE       14.0

@protocol RCScrollViewDelegate <NSObject>

- (void)scrollTo:(NSString *) pageName;
- (void)startScroll;
- (void)stopScroll;

@end

typedef enum : NSInteger {
    MenuTop,
    MenuBottom
} MenuPosition;

@interface MenuSkypeViewController : UIViewController

-(void)setMenuPosition:(MenuPosition)position;
-(void)setMenuItems:(NSArray *)menuItems contentItems:(NSArray *)contentItems;
-(void)moveToNewIndex:(NSInteger)index;
-(void)moveToNewIndexWithoutAnimation:(NSInteger)index;
@property (nonatomic, assign) id<RCScrollViewDelegate> delegate;

@end
