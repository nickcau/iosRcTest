//
//  XHScrollMenu.m
//  XHScrollMenu
//
//  Created by 曾 宪华 on 14-3-8. Updated by lamsion.chen on 22/05/14.
//  Copyright (c) 2014年 曾宪华
//

#import "XHScrollMenu.h"

#import "UIScrollView+XHVisibleCenterScroll.h"
#import "RCColor.h"
#import "RCButton.h"

#define kXHMenuButtonBaseTag 100

@interface XHScrollMenu () <UIScrollViewDelegate> {
    
}

@property (nonatomic, strong) UIImageView *leftShadowView;
@property (nonatomic, strong) UIImageView *rightShadowView;

@property (nonatomic, strong) UIButton *managerMenusButton;

@property (nonatomic, strong) NSMutableArray *menuButtons;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic) CGFloat kXHMenuButtonStarX;

@property (nonatomic) CGFloat kXHMenuButtonPaddingX;

@end

@implementation XHScrollMenu

#pragma mark - Propertys

- (NSMutableArray *)menuButtons {
    if (!_menuButtons) {
        _menuButtons = [[NSMutableArray alloc] initWithCapacity:self.menus.count];
    }
    return _menuButtons;
}

#pragma mark - Action

- (void)managerMenusButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(scrollMenuDidManagerSelected:)]) {
        [self.delegate scrollMenuDidManagerSelected:self];
    }
}

- (void)menuButtonSelected:(UIButton *)sender {
    [self.menuButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj == sender) {
            sender.selected = YES;
        } else {
            UIButton *menuButton = obj;
            menuButton.selected = NO;
        }
    }];
    [self.delegate menuButtonClicked:(sender.tag - 100)];
    [self setSelectedIndex:sender.tag - kXHMenuButtonBaseTag animated:YES calledDelegate:YES];
}

- (void)scrollTo:(NSUInteger)index
{
    [self.delegate menuButtonClicked:index];
    [self setSelectedIndex:index animated:YES calledDelegate:YES];
}

- (void)scrollToCurrentPage
{
    [self.scrollView scrollRectToVisible:[self rectForSelectedItemAtIndex:self.selectedIndex] animated:YES];
}




#pragma mark - Life cycle

- (UIImageView *)getShadowView:(BOOL)isLeft {
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, CGRectGetHeight(self.view.bounds))];
    shadowImageView.image = [UIImage imageNamed:(isLeft ? @"leftShadow" : @"rightShadow")];
//    /** keep this code due with layer shadow
    shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowImageView.layer.shadowOffset = CGSizeMake((isLeft ? 2.5 : -1.5), 0);
    shadowImageView.layer.shadowRadius = 3.2;
    shadowImageView.layer.shadowOpacity = 0.5;
    shadowImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowImageView.bounds].CGPath;
//     */
    
    shadowImageView.hidden = isLeft;
    return shadowImageView;
}

- (void)loadView {
    [super loadView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _selectedIndex = 0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_managerMenusButton.frame), CGRectGetHeight(self.view.bounds))];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _indicatorView = [XHIndicatorView initIndicatorView];
    _indicatorView.alpha = 0.;
    
    _badgeNum = 2;
    
//    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_back2"]];
//    [self.view addSubview:bgView];
    
//    [self.view.layer setBorderWidth:1.0f];
//    [self.view.layer setBorderColor:[RCColor RCColorRefGray:0.5f]];
    
    [self.view addSubview:self.scrollView];
    
    self.kXHMenuButtonStarX = 20;
    self.kXHMenuButtonPaddingX = 14;
    
}



- (void)setupIndicatorFrame:(CGRect)menuButtonFrame animated:(BOOL)animated callDelegate:(BOOL)called {
    [UIView animateWithDuration:(animated ? 0.1 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _indicatorView.frame = CGRectMake(CGRectGetMinX(menuButtonFrame), CGRectGetHeight(self.view.bounds) - kXHIndicatorViewHeight, CGRectGetWidth(menuButtonFrame), kXHIndicatorViewHeight);
    } completion:^(BOOL finished) {
        if (called) {
            if ([self.delegate respondsToSelector:@selector(scrollMenuDidSelected:menuIndex:)]) {
                [self.delegate scrollMenuDidSelected:self menuIndex:self.selectedIndex];
            }
        }
    }];
}

- (RCButton *)getButtonWithMenu:(XHMenu *)menu {
    CGSize buttonSize = CGSizeMake(60.0f, 30.0f);


    RCButton *button = [[RCButton alloc] initWithFrame:CGRectMake(10, 0, buttonSize.width, buttonSize.height)];
    
    [button.imageView setImage:[UIImage imageNamed:menu.title]];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(-5.0f, 0, 5.0f, 0);
    
    button.rctitle.text = menu.title;
    
    [button.rctitle setTextColor:[RCColor RCTitleNormal:1.0]];
    
    if([button.rctitle.text isEqual:@"Messages"]){
        [button.badge setText:[NSString stringWithFormat:@"%d", _badgeNum]];
    }else{
        [button.badge setHidden:YES];
    }
    
    
    [button setImage:[UIImage imageNamed:[menu.title stringByAppendingString:@"_normal"]] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:[menu.title stringByAppendingString:@"_selected"]] forState:(UIControlStateSelected)];
    menu.titleHighlightedColor = [RCColor RCBlue:1.0f];
    menu.titleSelectedColor = [RCColor RCBlue:1.0f];
    
    
    [button addTarget:self action:@selector(menuButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark - Public

- (CGRect)rectForSelectedItemAtIndex:(NSUInteger)index {
    CGRect rect = ((UIView *)self.menuButtons[index]).frame;
    return rect;
}

- (XHMenuButton *)menuButtonAtIndex:(NSUInteger)index {
    return self.menuButtons[index];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate {
    
    [_scrollTimer invalidate];
//    self.currentBtnRect = [self rectForSelectedItemAtIndex:self.selectedIndex];
    
    if (_selectedIndex == selectedIndex)
        return;
    RCButton *towardsButton = [self.menuButtons objectAtIndex:selectedIndex];
    towardsButton.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        towardsButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        towardsButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    RCButton *prousButton = [self.menuButtons objectAtIndex:_selectedIndex];
    prousButton.selected = (_selectedIndex == selectedIndex && !selectedIndex);
    
    [UIView animateWithDuration:0.25 animations:^{
        prousButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    [prousButton.rctitle setTextColor:[RCColor RCTitleNormal:1.0]];
   
    _selectedIndex = selectedIndex;
    RCButton *selectedMenuButton = [self menuButtonAtIndex:_selectedIndex];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.scrollView scrollRectToVisibleCenteredOn:selectedMenuButton.frame animated:NO];
    } completion:^(BOOL finished) {
        [self setupIndicatorFrame:selectedMenuButton.frame animated:aniamted callDelegate:calledDelgate];
        [selectedMenuButton.rctitle setTextColor:[RCColor RCBlue:1.0]];
    }];
}

- (void)reloadData {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RCButton class]]) {
            [((RCButton *)obj) removeFromSuperview];
        }
    }];
    if (self.menuButtons.count)
        [self.menuButtons removeAllObjects];
    
    // layout subViews
    CGFloat contentWidth = _kXHMenuButtonStarX;
    
    CGFloat singleButtonWidth = 45.0f;
    CGFloat slidingMenuWidth = _kXHMenuButtonStarX + (_kXHMenuButtonPaddingX + singleButtonWidth)*self.menus.count;
    CGFloat deviceWidth = self.view.bounds.size.width;

    if (slidingMenuWidth < deviceWidth) {
        _kXHMenuButtonStarX = (deviceWidth - slidingMenuWidth)*0.25;
        _kXHMenuButtonPaddingX = _kXHMenuButtonPaddingX + (_kXHMenuButtonStarX)/(self.menus.count-1);
    }
    
    
    for (XHMenu *menu in self.menus) {
        NSUInteger index = [self.menus indexOfObject:menu];
        RCButton *menuButton = [self getButtonWithMenu:menu];
        menuButton.tag = kXHMenuButtonBaseTag + index;
        CGRect menuButtonFrame = menuButton.frame;
        CGFloat buttonX = 0;
        
        
        
        if (index) {
            buttonX = _kXHMenuButtonPaddingX + CGRectGetMaxX(((UIButton *)(self.menuButtons[index - 1])).frame);
        } else {
            buttonX = _kXHMenuButtonStarX;
//            [menuButton.rctitle  setTextColor:[RCColor RCBlue:1]];
        }
        
        menuButtonFrame.origin = CGPointMake(buttonX, CGRectGetMidY(self.view.bounds) - (CGRectGetHeight(menuButtonFrame) / 2.0));
        menuButton.frame = menuButtonFrame;
        [self.scrollView addSubview:menuButton];
        [self.menuButtons addObject:menuButton];
        
        // scrollView content size width
        if (index == self.menus.count - 1) {
            contentWidth += CGRectGetMaxX(menuButtonFrame);
        }
        
        
        if (self.selectedIndex == index) {
            menuButton.selected = YES;
            [menuButton.rctitle setTextColor:[RCColor RCBlue:1.0]];
            // indicator
            _indicatorView.alpha = 1.;
            [self setupIndicatorFrame:menuButtonFrame animated:NO callDelegate:NO];
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.scrollView.frame))];
    [self setSelectedIndex:self.selectedIndex animated:NO calledDelegate:YES];
}



#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    UIButton *currentButton =  self.menuButtons[self.selectedIndex];
//    self.currentBtnRect = currentButton.bounds;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(scrollToCurrentPage)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat contentSizeWidth = (NSInteger)scrollView.contentSize.width;
    CGFloat scrollViewWidth = CGRectGetWidth(scrollView.bounds);
    if (contentSizeWidth == scrollViewWidth) {
        self.leftShadowView.hidden = YES;
        self.rightShadowView.hidden = YES;
    } else if (contentSizeWidth <= scrollViewWidth) {
        self.leftShadowView.hidden = YES;
        self.rightShadowView.hidden = YES;
    } else {
        if (contentOffsetX > 0) {
            self.leftShadowView.hidden = NO;
        } else {
            self.leftShadowView.hidden = YES;
        }
        
        if ((contentOffsetX + scrollViewWidth) >= contentSizeWidth) {
            self.rightShadowView.hidden = YES;
        } else {
            self.rightShadowView.hidden = NO;
        }
    }
    
}

@end
