//
//  MenuSkypeViewController.m
//  MenuSkype
//
//  Created by Charles-Hubert Basuiau on 01/07/2014.
//  Copyright (c) 2014 Charles-Hubert Basuiau. All rights reserved.
//

#import "MenuSkypeViewController.h"
#import "RCColor.h"

#define ANIMATION_DURATION  0.4
@interface MenuSkypeViewController () <UIScrollViewDelegate> {
    UIScrollView *menu;
    UIScrollView *content;
    
    NSArray *menuItems;
    NSArray *contentItems;
    
    NSInteger nbItems;
    NSInteger currentIndex;
    
    CGFloat lastContentOffset;
    MenuPosition menuPostion;
}

@end

@implementation MenuSkypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentIndex = 0;
    lastContentOffset = 0.0;
}

- (void)loadView
{
    [super loadView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Menu
    /////////
    CGRect menuFrame = self.view.bounds;
    menuFrame.size.height = MENU_HEIGHT;
    if (menuPostion != MenuTop) {
        menuFrame.origin.y = self.view.bounds.size.height-MENU_HEIGHT;
    }
    menu = [[UIScrollView alloc] initWithFrame:menuFrame];
    menu.showsHorizontalScrollIndicator = NO;
    [menu setBackgroundColor:[RCColor RCBlue:1.0]];
    [self.view addSubview:menu];
    
    //Content
    /////////////
    content = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    content.delegate = self;
    [content setPagingEnabled:YES];
    content.showsHorizontalScrollIndicator = NO;
    content.bounces = NO;
    [content setContentSize:CGSizeMake(3*self.view.bounds.size.width, self.view.bounds.size.height)];    //3 for pages -1 0 1
    [self.view addSubview:content];
    
    
    //Menu listener
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [content addGestureRecognizer:tap];
    
    [self setMenuContent];
    [self setScrollViewContent];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Menu
    /////////
    CGRect menuFrame = self.view.bounds;
    menuFrame.size.height = MENU_HEIGHT;
    if (menuPostion != MenuTop) {
        menuFrame.origin.y = self.view.bounds.size.height-MENU_HEIGHT;
    }
    menu = [[UIScrollView alloc] initWithFrame:menuFrame];
    menu.showsHorizontalScrollIndicator = NO;
    [menu setBackgroundColor:[RCColor RCBlue:1.0]];
    [self.view addSubview:menu];
    
    //Content
    /////////////
    content = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    content.delegate = self;
    [content setPagingEnabled:YES];
    content.showsHorizontalScrollIndicator = NO;
    content.bounces = NO;
    [content setContentSize:CGSizeMake(3*self.view.bounds.size.width, self.view.bounds.size.height)];    //3 for pages -1 0 1
    [self.view addSubview:content];
    
    
    //Menu listener
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [content addGestureRecognizer:tap];
    
    [self setMenuContent];
    [self setScrollViewContent];
    
   }

#pragma mark - public methods -

#pragma mark Config

-(void)setMenuPosition:(MenuPosition)position {
    menuPostion = position;
}

-(void)setMenuItems:(NSArray *)pMenuItems contentItems:(NSArray *)pContentItems {
    if ((pMenuItems.count != pContentItems.count) || pMenuItems==0) {
        NSLog(@"Error : you should have as many menuItems as contentItems");
        return;
    }
    for (UIViewController *V in contentItems) {
        [self addChildViewController:V];
    }
    
    menuItems = [pMenuItems copy];
    contentItems = [pContentItems copy];
    nbItems = menuItems.count;
}

#pragma mark - private methods -

#pragma mark Contents

-(void)setMenuContent {
    //Clean all + call ViewDidAppear to load infos if needed
    for (UIView *tmpView in [menu subviews]) {
        [tmpView removeFromSuperview];
    }
    
    //Load menu item -1 0 1
    CGFloat x = 0;
    for (int i=-1; i<nbItems; i++) {
        x+= MARGE;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 35, self.view.frame.size.width, MENU_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        label.text = menuItems[(nbItems+i+currentIndex)%nbItems];
        [label sizeToFit];
        x += label.frame.size.width + MARGE;
        label.alpha = 0.5;
        [label setTextColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:menuItems[(nbItems+i+currentIndex)%nbItems]]];
        [imageView setCenter:CGPointMake(label.center.x, label.center.y-20)];
        
        [menu addSubview:label];
        [menu addSubview:imageView];
        if (i == 0) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                label.alpha = 1.0;
                [label setTextColor:[RCColor RCOrange:1.0]];
                [self.delegate scrollTo:label.text];
                [imageView setImage:[UIImage imageNamed:[menuItems[(nbItems+i+currentIndex)%nbItems] stringByAppendingString:@"_selected"]]];
            }];
        }
    }
    [menu setContentSize:CGSizeMake(x, MENU_HEIGHT)];
}

-(void)setScrollViewContent {
    //Clean all + call ViewDidAppear to load infos if needed
    for (UIView *tmpView in [content subviews]) {
        [tmpView removeFromSuperview];
    }
    //Load pages -1 0 1
    CGRect rect = content.bounds;
    if (menuPostion == MenuTop) {
        rect.origin.y += menu.frame.size.height;
    }
    rect.size.height -= menu.frame.size.height;
    rect.origin.x = 0;
    [[[contentItems objectAtIndex:((nbItems+currentIndex-1)%nbItems)] view] setFrame:rect];
    [content addSubview:[[contentItems objectAtIndex:((nbItems+currentIndex-1)%nbItems)] view]];
    rect.origin.x = rect.size.width;
    CGRect tmpRect = rect;
    [[[contentItems objectAtIndex:(currentIndex%nbItems)] view] setFrame:rect];
    [content addSubview:[[contentItems objectAtIndex:(currentIndex%nbItems)] view]];
    rect.origin.x = 2*rect.size.width;
    [[[contentItems objectAtIndex:((currentIndex+1)%nbItems)] view] setFrame:rect];
    [content addSubview:[[contentItems objectAtIndex:((currentIndex+1)%nbItems)] view]];
    
    //Center on page 0
    [content scrollRectToVisible:tmpRect animated:NO];
}

#pragma mark Tap handling

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint touchPoint = [tapRecognizer locationInView: menu];
    if (touchPoint.y < menu.frame.size.height && touchPoint.y > 0) {
        CGFloat x = 0;
        int i = -1;
        while (x < touchPoint.x) {
            x+= MARGE;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 35, self.view.frame.size.width, MENU_HEIGHT)];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            label.text = menuItems[(nbItems+i+currentIndex)%nbItems];
            [label sizeToFit];
            x += label.frame.size.width + MARGE;
            i++;
        }
        i--;
        if (i!=0) {
            //menu item tap
            [self moveToNewIndex:i];
        }
    }
}

#pragma mark Moves

-(void)moveToNewIndex:(NSInteger)index {
    if (index == 1) {
        CGRect newRect = content.bounds;
        newRect.origin.x += self.view.frame.size.width;
        [content scrollRectToVisible:newRect animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:content afterDelay:ANIMATION_DURATION];
    } else { //can be improve
        CGRect newRect = content.bounds;
        newRect.origin.x += self.view.frame.size.width;
        
        //Move instantly to get the good page
        for (int i=0; i<index-1; i++) {
            [content scrollRectToVisible:newRect animated:NO];
            [self scrollViewDidEndDecelerating:content];
        }
        //Now anim
        [content scrollRectToVisible:newRect animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:content afterDelay:ANIMATION_DURATION];
    }
}

-(void)moveToNewIndexWithoutAnimation:(NSInteger)index {
    if (index == 1) {
        CGRect newRect = content.bounds;
        newRect.origin.x += self.view.frame.size.width;
        [content scrollRectToVisible:newRect animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:content afterDelay:ANIMATION_DURATION];
    } else { //can be improve
        CGRect newRect = content.bounds;
        newRect.origin.x += self.view.frame.size.width;
        
        //Move instantly to get the good page
        for (int i=0; i<index; i++) {
            [content scrollRectToVisible:newRect animated:NO];
            [self scrollViewDidEndDecelerating:content];
        }
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.delegate stopScroll];
    NSInteger nPage = scrollView.contentOffset.x/self.view.frame.size.width;
    switch (nPage) {
        case 0: //Prev
            currentIndex--;
            if (currentIndex<0) {
                currentIndex+=nbItems;
            }
            [self setMenuContent];
            [self setScrollViewContent];
            break;
        case 2: //Next
            currentIndex++;
            if (currentIndex == nbItems) {
                currentIndex=0;
            }
            [self setMenuContent];
            [self setScrollViewContent];
            break;
        default:
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delegate startScroll];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == content) {
        //Get width of label 0
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, MENU_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        label.text = menuItems[(nbItems+currentIndex-1)%nbItems];
        [label sizeToFit];
        CGFloat width0 = label.frame.size.width + 2*MARGE;
        
        //Get width of label 1
        label.text = menuItems[currentIndex];
        [label sizeToFit];
        CGFloat width1 = label.frame.size.width + 2*MARGE;
        
        //Get width of label 0
        CGFloat x = content.contentOffset.x - self.view.frame.size.width;
        if (lastContentOffset > content.contentOffset.x) {
            [menu setContentOffset:CGPointMake(width0 + x * width0/self.view.frame.size.width, menu.contentOffset.y)];
        } else {
            [menu setContentOffset:CGPointMake(width0 + x * width1/self.view.frame.size.width,
                                               menu.contentOffset.y)];
        }
        //Save old postion to know direction
        lastContentOffset = content.contentOffset.x;
    }
}

@end
