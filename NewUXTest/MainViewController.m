//
//  ViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 20/04/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "MainViewController.h"
#import "XHMenu.h"
#import "XHScrollMenu.h"

#import "DocumentsViewController.h"
#import "ContactsViewController.h"
#import "FavoritesViewController.h"
#import "CallLogViewController.h"
#import "MessagesViewController.h"
#import "DialPadViewController.h"

#import "FavoritesViewController.h"
#import "DialPadViewController.h"






#import "RCOverlayWindow.h"
#import "FRDLivelyButton.h"

#import "CNPGridMenu.h"
#import "RCColor.h"
#import "RCMenu/RCMenu.h"
#import "RCMenu/RCMenuItem.h"
#import "ZFModalTransitionAnimator.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#import "RCColor.h"

@interface MainViewController () <XHScrollMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XHScrollMenu *scrollMenu;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) NSMutableArray *itemMenus;
@property (nonatomic, assign) BOOL shouldObserving;
@property (nonatomic, strong) UIView *actionBG;
@property (nonatomic, strong) UIImageView *startIconView;

@property (nonatomic, strong) UIButton *avatar;

@property int unreadCount;

@property (nonatomic, strong) NSString *selectedMenu;
@property (nonatomic, strong) NSString *contactSelectedTab;
@property (nonatomic, strong) NSString *msgSelectedTab;
@property (nonatomic, strong) NSString *callLogSelectedTab;
@property (nonatomic, strong) NSString *docSelectedTab;
@property (nonatomic, strong) RCOverlayWindow *overlayWindow;

@property (nonatomic) Boolean notifyFlag;
@property (nonatomic) Boolean inRootFlag;
@property (nonatomic) Boolean isExpanding;

@property (nonatomic, strong) CNPGridMenu *gridMenu;
@property (nonatomic, strong) UILabel *dialLabel;
@property (nonatomic, strong) UILabel *normalLabel;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) NSTimer *rcTimer;

//@property (nonatomic, strong) UIImageView *menuShot;


@end


@implementation MainViewController

@synthesize blurView = _blurView;

- (void)didSelectedCallLogTabIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self setCallLogSelectedTab:@"All"];
            break;
        case 1:
            [self setCallLogSelectedTab:@"Missed"];
            break;
    }
    
}

- (void)didSelectedMessagesTabIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self setMsgSelectedTab:@"All"];
            break;
        case 1:
            [self setMsgSelectedTab:@"Voice"];
            break;
        case 2:
            [self setMsgSelectedTab:@"Fax"];
            break;
        case 3:
            [self setMsgSelectedTab:@"Text"];
            break;
            
    }
}

- (void)didSelectedDocumentsTabIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self setDocSelectedTab:@"Documents"];
            break;
        case 1:
            [self setDocSelectedTab:@"Drafts"];
            break;
        case 2:
            [self setDocSelectedTab:@"Outbox"];
            break;
    }
}

- (void)didSelectedContactsTabIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self setContactSelectedTab:@"Favorites"];
            break;
        case 1:
            [self setContactSelectedTab:@"Personal"];
            break;
        case 2:
            [self setContactSelectedTab:@"Company"];
            break;
            
    }
}

- (id)init{
    self = [super init];
    if (self) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil ];
        
        UIView *leftView = [[UIView alloc]init];
        [leftView setFrame:CGRectMake(0, 0, 100, 88)];
        
        _avatar = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 36, 36)];
        [_avatar setImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];
        
        _avatar.imageView.layer.masksToBounds = YES;
        _avatar.imageView.layer.cornerRadius = 18;
        [_avatar addTarget:self action:@selector(showAvatar) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(26, (7*_avatar.bounds.size.height)/10, 10.0f, 10.0f)];
        statusView.layer.cornerRadius = 5.0;
        [statusView.layer setBorderWidth:1.5];
        [statusView.layer setBorderColor:[RCColor RCColorRefWhite:1]];
        
        statusView.image = [UIImage imageNamed:@"status_green"];
        [_avatar addSubview:statusView];
        
        [leftView addSubview:_avatar];
        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete"]]];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Contact+"]]];
        
//        [self.navigationItem.leftBarButtonItem setAction:@selector(showAvatar)];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        
        _dialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        [_dialLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
        _dialLabel.text = @"";
//        [_dialLabel setAlpha:0.5];
        [_dialLabel setTextColor:[UIColor darkGrayColor]];
        [_dialLabel setTextAlignment:NSTextAlignmentCenter];
        
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        _normalLabel.text = @"Messages";
        [_normalLabel setFont:[UIFont systemFontOfSize:18]];
        [_normalLabel setTextColor:[UIColor blackColor]];
        [_normalLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.navigationItem setTitleView:_dialLabel];
        
        self.isExpanding = NO;
        
    }
    return self;
}

- (void) gotoMsg
{
    [_scrollMenu scrollTo:1];
}

- (void) showAvatar{
    
//    MeController *avatarCon = [[MeController alloc] init];
//    
////    [avatarCon setUnreadCount:_unreadCount];
//    [self.navigationController pushViewController:avatarCon animated:YES];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void) showSettings:(id)sender{
//    UIViewController *msgCon = [[MoreViewController alloc] init];
//    
//    [self.navigationController presentViewController:msgCon animated:YES completion:Nil ];
}

- (NSMutableArray *)menus {
    if (!_menus) {
        _menus = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _menus;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.shouldObserving = YES;
    
    CallLogViewController *calllogController = [[CallLogViewController alloc] init];
    
    MessagesViewController *msgController = [[MessagesViewController alloc] init];
    
    ContactsViewController *contactsController = [[ContactsViewController alloc] init];
    
    DocumentsViewController *docController = [[DocumentsViewController alloc] init];
    
    FavoritesViewController *reportController = [[FavoritesViewController alloc] init];
    
    
    DialPadViewController *dialController = [[DialPadViewController alloc] init];
    
    _scrollMenu = [[XHScrollMenu alloc] init];
    _scrollMenu.view.frame = CGRectMake(50,self.view.bounds.size.height - 49, self.view.bounds.size.width - 50, 49);
    [_scrollMenu.view setBackgroundColor:[RCColor RCTabBarBG:1]];
    
    _scrollMenu.delegate = self;
    //    _scrollMenu.selectedIndex = 3;
    
    _blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)];
    [_blurView setBackgroundColor:[UIColor whiteColor]];
    
    _blurView.alpha = 0.0f;
    
    [self.view addSubview:self.scrollMenu.view];
    
    
    //    [self.view bringSubviewToFront:self.tabBarController.view];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height - 49)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    
    [self.view addSubview:_blurView];
    
    for (int i = 0; i < 6; i ++) {
        XHMenu *menu = [[XHMenu alloc] init];
        
        NSString *title = nil;
        switch (i) {
            case 0:
                title = @"Dialpad";
                break;
            case 1:
                title = @"Messages";
                break;
            case 2:
                title = @"Call Log";
                break;
            case 3:
                title = @"Contacts";
                break;
            case 4:
                title = @"Favorites";
                break;
            case 5:
                title = @"Documents";
                break;
        }
        menu.title = title;
        
        [self.menus addObject:menu];
        
    }
    
    _viewArrayOfPages = [@[] mutableCopy];
    
    [self addChildViewController:dialController];
    [self addChildViewController:msgController];
    [self addChildViewController:calllogController];
    [self addChildViewController:contactsController];
    [self addChildViewController:reportController];
    [self addChildViewController:docController];

    
    
    for (UIViewController *controller in self.childViewControllers) {
        NSUInteger index = [self.childViewControllers indexOfObject:controller];
        
        controller.view.frame = CGRectMake(index * CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
        //        NSLog(@"n: %f",index * CGRectGetWidth(_scrollView.bounds));
        
        [_viewArrayOfPages addObject:controller.view];
        
        [_scrollView addSubview:controller.view];
    }
//
//    
    [_scrollView setContentSize:CGSizeMake(self.menus.count * CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds))];
    [self startObservingContentOffsetForScrollView:_scrollView];
    
    _scrollMenu.menus = self.menus;
    [_scrollMenu reloadData];
//    
    self.notifyFlag = TRUE;
//    
//    self.overlayWindow = [[RCOverlayWindow alloc] initWithFrame:CGRectMake(0, -64, self.view.bounds.size.width, 64)];
//    self.overlayWindow.hidden = NO;
//    [self.overlayWindow makeKeyAndVisible];
//    [self.overlayWindow.noticeView addTarget:self action:@selector(dismissNewNotification) forControlEvents:UIControlEventTouchUpInside];
//    [self.overlayWindow.noticeView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    
    UIImageView *menuBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_back2"]];
    [menuBg setFrame:CGRectMake(0, self.view.bounds.size.height-49, 60, 49)];
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 50, self.view.bounds.size.width, 1)];
    [border setBackgroundColor:[RCColor RCColorTableSaperator:1]];
    
    [self.view addSubview:menuBg];
    [self.view addSubview:border];
    
    
    UIImage *meetingImage = [UIImage imageNamed:@"meetings.png"];
    UIImage *textImage = [UIImage imageNamed:@"text.png"];
    UIImage *confImage = [UIImage imageNamed:@"conference.png"];
    UIImage *faxImage = [UIImage imageNamed:@"fax.png"];
    
    RCMenuItem *meetingsMenuItem = [[RCMenuItem alloc] initWithImage:meetingImage
                                                    highlightedImage:meetingImage
                                                        ContentImage:meetingImage
                                             highlightedContentImage:nil
                                                               title:@"Meetings"];
    RCMenuItem *textMenuItem = [[RCMenuItem alloc] initWithImage:textImage
                                                highlightedImage:textImage
                                                    ContentImage:textImage
                                         highlightedContentImage:nil
                                                           title:@"Text"];
    
    RCMenuItem *confMenuItem = [[RCMenuItem alloc] initWithImage:confImage
                                                highlightedImage:confImage
                                                    ContentImage:confImage
                                         highlightedContentImage:nil
                                                           title:@"Conference"];
    
    RCMenuItem *faxMenuItem = [[RCMenuItem alloc] initWithImage:faxImage
                                               highlightedImage:faxImage
                                                   ContentImage:faxImage
                                        highlightedContentImage:nil
                                                          title:@"Fax"];
    
    self.itemMenus = [NSMutableArray arrayWithObjects:textMenuItem, meetingsMenuItem, confMenuItem, faxMenuItem, nil];
    
    
    RCMenuItem *startItem = [[RCMenuItem alloc] initWithImage:[UIImage imageNamed:@"action"]
                                             highlightedImage:[UIImage imageNamed:@"action"]
                                                 ContentImage:[UIImage imageNamed:@"action"]
                                      highlightedContentImage:[UIImage imageNamed:@"action"]
                                                        title:@"Start"];
    
    [startItem.itemLabel setHidden:YES];
    _menu = [[RCMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:self.itemMenus];
    _menu.delegate = self;
    
    _menu.menuWholeAngle = M_PI;
    _menu.farRadius = 130.0f;
    _menu.endRadius = 120.0f;
    _menu.radius = self.view.bounds.size.width/2 - 25;
    _menu.animationDuration = .2;
    _menu.startPoint = CGPointMake(25,self.view.bounds.size.height - 25);
    
//    self.menuShot = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height - 49, self.view.bounds.size.width - 50, 49)];
//    [self.menuShot setHidden:YES];
//    [self.view addSubview:self.menuShot];
    
    [self.view addSubview:_menu];    
}

- (void)dismissNewNotification
{
    [_rcTimer invalidate];
    [self slideUpNoti];
}


- (void)showCompanyFilters
{
//    UIViewController *companyFiltersView = [[CompanyFiltersViewController alloc] init];
//    
//    UINavigationController *companyFiltersNav = [[UINavigationController alloc] initWithRootViewController:companyFiltersView];
//    
//    [self presentViewController:companyFiltersNav animated:YES completion:Nil ];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIViewController *controller in self.childViewControllers) {
        NSUInteger index = [self.childViewControllers indexOfObject:controller];
        controller.view.tag = index;
        controller.view.restorationIdentifier = [NSString stringWithFormat: @"%lu", (unsigned long)index];
    }
}



- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)stopObservingContentOffset
{
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self stopObservingContentOffset];
}

- (void)scrollMenuDidSelected:(XHScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex {
    
    self.shouldObserving = YES;
    //    [self menuSelectedIndex:selectIndex];
}

- (void)scrollMenuDidManagerSelected:(XHScrollMenu *)scrollMenu {
    //    NSLog(@"scrollMenuDidManagerSelected");
}

- (void)menuSelectedIndex:(NSUInteger)index {
    
    XHMenu *menu= self.menus[index];
    
    self.title = menu.title;
    [self ChangeNavItem:self.title];
}

- (void) ChangeNavItem : (NSString *) title
{
    if ([title isEqualToString:@"Messages"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:nil];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
        [self.navigationItem setTitleView:_normalLabel];
        [_normalLabel setText:title];
    }
    if ([title isEqualToString:@"Call Log"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:nil];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
        [self.navigationItem setTitleView:_normalLabel];
        [_normalLabel setText:title];
    }
    if ([title isEqualToString:@"Contacts"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown_menu_normal"] style:UIBarButtonItemStylePlain target:self action:nil];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
        [self.navigationItem setTitleView:_normalLabel];
        [_normalLabel setText:title];
    }
    if ([title isEqualToString:@"Favorites"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown_menu_normal"] style:UIBarButtonItemStylePlain target:self action:nil];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
        [self.navigationItem setTitleView:_normalLabel];
        [_normalLabel setText:title];
    }
    if ([title isEqualToString:@"Documents"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:nil];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
        [self.navigationItem setTitleView:_normalLabel];
        [_normalLabel setText:title];
        [self newUnread];
    }
    if ([title isEqualToString:@"Dialpad"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        [self.navigationItem setTitleView:_dialLabel];
    }
}

#pragma mark - ScrollView delegate

- (void)menuButtonClicked:(NSUInteger)index
{
    CGRect viewBounds = self.scrollView.bounds;
    
    XHMenu *menu= self.menus[index];
    
    self.title = menu.title;
    [self ChangeNavItem:self.title];
    
    NSInteger count = _viewArrayOfPages.count;
    if (index < _scrollMenu.selectedIndex) {
        // slide to left
        for (int j=0; j<(_scrollMenu.selectedIndex - index); j++) {
            for (int i = 0; i < count; i++) {
                UIView *pageView = _viewArrayOfPages[i];
                //            NSLog(@"old tag: %i -- new tag: %i -- position: %f",pageView.tag,((pageView.tag + 1) % count),viewBounds.size.width * (((pageView.tag + 1) % count)));
                pageView.frame = CGRectMake(viewBounds.size.width * (pageView.tag = ((pageView.tag + 1) % count)), 0, viewBounds.size.width, self.view.bounds.size.height);
            };
        }
        
    }else if(index > _scrollMenu.selectedIndex){
        // slide to right
        for (int j=0; j<(index - _scrollMenu.selectedIndex); j++) {
            for (int i = 0; i < count; i++) {
                UIView *pageView = _viewArrayOfPages[i];
                //            NSLog(@"old tag: %i -- new tag: %i -- position: %f",pageView.tag,((pageView.tag + (count-1)) % count),viewBounds.size.width * (((pageView.tag + (count-1)) % count)));
                pageView.frame = CGRectMake(viewBounds.size.width * (pageView.tag = ((pageView.tag + (count-1)) % count)), 0, viewBounds.size.width, self.view.bounds.size.height);
                
            }
            
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect viewBounds = self.scrollView.bounds;
    CGFloat disX = scrollView.contentOffset.x;
    
    NSInteger count = _viewArrayOfPages.count;
    if (disX == 0) {
        // slide to left
        for (int i = 0; i < count; i++) {
            UIView *pageView = _viewArrayOfPages[i];
            //            NSLog(@"old tag: %i -- new tag: %i -- position: %f",pageView.tag,((pageView.tag + 1) % count),viewBounds.size.width * (((pageView.tag + 1) % count)));
            pageView.frame = CGRectMake(viewBounds.size.width * (pageView.tag = ((pageView.tag + 1) % count)), 0, viewBounds.size.width, self.view.bounds.size.height);
        };
    }else if(disX == viewBounds.size.width * 2){
        // slide to right
        for (int i = 0; i < count; i++) {
            UIView *pageView = _viewArrayOfPages[i];
            //            NSLog(@"old tag: %i -- new tag: %i -- position: %f",pageView.tag,((pageView.tag + (count-1)) % count),viewBounds.size.width * (((pageView.tag + (count-1)) % count)));
            pageView.frame = CGRectMake(viewBounds.size.width * (pageView.tag = ((pageView.tag + (count-1)) % count)), 0, viewBounds.size.width, self.view.bounds.size.height);
            
        }
    }
    
    for (int i = 0; i < count; i++) {
        UIView *pageView = _viewArrayOfPages[i];
        if (pageView.tag == 1) {
            int currentPage = i;
            //    NSLog(@"current index: %i",currentPage);
            
            XHMenu *menu= self.menus[currentPage];
            
            self.title = menu.title;
            
            [self ChangeNavItem:self.title];
            
            [self.scrollMenu setSelectedIndex:currentPage animated:NO calledDelegate:NO];
        }
        
    }
    self.scrollView.contentOffset = CGPointMake(viewBounds.size.width, 0);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{}


- (void)rotateStartBtn
{
    if (self.isExpanding) {
        self.isExpanding = NO;
    }else{
        self.isExpanding = YES;
        [self.blurView setAlpha:.95];
        [self.navigationController.navigationBar setHidden:YES];
//        [self.menuShot setImage:[RCColor imageWithView:self.scrollMenu.view]];
//        [self.menuShot setHidden:NO];
    }
    
}



- (void) playSound
{
//    SystemSoundID soundID;
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"button05" ofType:@"wav"];
//    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
//    
//    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)(soundUrl), &soundID);
//    AudioServicesPlaySystemSound(soundID);
    
}

- (void)newUnread
{
    [self.overlayWindow setFrame:CGRectMake(0, -64, self.view.bounds.size.width, 64)];
    
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:100
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.overlayWindow setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
                         
                     } completion:^(BOOL finished) {
                         
                        _rcTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(slideUpNoti)
                                                        userInfo:nil
                                                         repeats:NO];
                         
                         
                                              }];
}

- (void)slideUpNoti
{
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.overlayWindow setFrame:CGRectMake(0, -64, self.view.bounds.size.width, 64)];
                         
                     } completion:^(BOOL finished) {
                         _scrollMenu.badgeNum ++;
                         [_scrollMenu reloadData];
                     }];

}

- (void)rcMenu:(RCMenu *)menu didSelectIndex:(NSInteger)idx
{
    
//    [self playSound];
//    
//    RCMenuItem *item = self.itemMenus[idx];
//    
//    CGPoint animatePoint = item.center;
//    
//    
//
//    CGFloat duration = .5f;
//    
//    if ([item.itemLabel.text isEqual:@"Meetings"]) {
//        
//        UIViewController *meetingCon = [[MeetingsViewController alloc] init];
//        UINavigationController *modalVC = [[UINavigationController alloc] initWithRootViewController:meetingCon];
//        modalVC.modalPresentationStyle = UIModalPresentationCustom;
//        
//        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
//        self.animator.dragable = YES;
//        self.animator.bounces = NO;
//        self.animator.behindViewAlpha = 0.7f;
//        self.animator.behindViewScale = 0.7f;
//        self.animator.transitionDuration = duration;
//        self.animator.direction = ZFModalTransitonDirectionBottom;
//        self.animator.orinPoint = animatePoint;
//        
//        modalVC.transitioningDelegate = self.animator;
//        [self presentViewController:modalVC animated:YES completion:nil];
//        
//    }
//    
//    if ([item.itemLabel.text isEqual:@"Fax"]) {
//        UIViewController *faxCon = [[FaxViewController alloc] init];
//        
//        UINavigationController *modalVC = [[UINavigationController alloc] initWithRootViewController:faxCon];
//        modalVC.modalPresentationStyle = UIModalPresentationCustom;
//        
//        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
//        self.animator.dragable = YES;
//        self.animator.bounces = NO;
//        self.animator.behindViewAlpha = 0.7f;
//        self.animator.behindViewScale = 0.7f;
//        self.animator.transitionDuration = duration;
//        self.animator.orinPoint = animatePoint;
//        self.animator.direction = ZFModalTransitonDirectionBottom;
//        
//        
//        modalVC.transitioningDelegate = self.animator;
//        [self presentViewController:modalVC animated:YES completion:nil];
//    }
//    
//    if ([item.itemLabel.text isEqual:@"Text"]) {
//        UIViewController *msgCon = [[TextMessageViewController alloc] init];
//        
//        UINavigationController *modalVC = [[UINavigationController alloc] initWithRootViewController:msgCon];
//        modalVC.modalPresentationStyle = UIModalPresentationCustom;
//        
//        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
//        self.animator.dragable = YES;
//        self.animator.bounces = NO;
//        self.animator.behindViewAlpha = 0.7f;
//        self.animator.behindViewScale = 0.7f;
//        self.animator.transitionDuration = duration;
//        self.animator.orinPoint = animatePoint;
//        self.animator.direction = ZFModalTransitonDirectionBottom;
//        
//        
//        modalVC.transitioningDelegate = self.animator;
//        [self presentViewController:modalVC animated:YES completion:nil];
//
//    }
//    
//    if ([item.itemLabel.text isEqual:@"Conference"]) {
//        UIViewController *confCon = [[ConferenceViewController alloc] init];
//        
//        UINavigationController *modalVC = [[UINavigationController alloc] initWithRootViewController:confCon];
//        modalVC.modalPresentationStyle = UIModalPresentationCustom;
//        
//        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
//        self.animator.dragable = YES;
//        self.animator.bounces = NO;
//        self.animator.behindViewAlpha = 0.7f;
//        self.animator.behindViewScale = 0.7f;
//        self.animator.transitionDuration = duration;
//        self.animator.orinPoint = animatePoint;
//        self.animator.direction = ZFModalTransitonDirectionBottom;
//        
//        
//        modalVC.transitioningDelegate = self.animator;
//        [self presentViewController:modalVC animated:YES completion:nil];
//    }
//    
//    [self.blurView setAlpha:0];
////    [self.menuShot setHidden:YES];
//    [self.navigationController.navigationBar setHidden:NO];
}

- (void)rcMenuDidFinishAnimationClose:(RCMenu *)menu {
    //    NSLog(@"Menu was closed!");
    //    self.men.alpha = 0.0f;
    //    [self rotateStartBtn];
    
    [self.blurView setAlpha:0];
//    [self.menuShot setHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)rcMenuDidFinishAnimationOpen:(RCMenu *)menu {
    //    NSLog(@"Menu is open!");
    //    [self rotateStartBtn];
    
}

- (void)startOpen
{
    //    [self.blurView setAlpha:0.8f];
    [self playSound];
    [self rotateStartBtn];
    
}

- (void)startClose
{
    [self playSound];
    [self rotateStartBtn];
}



@end
