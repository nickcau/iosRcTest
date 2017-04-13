//
//  NoticeWindow.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/22/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "NoticeWindow.h"
#import "RCColor.h"
#import "MenuSkypeViewController.h"

@interface NoticeWindow ()
@end

@implementation NoticeWindow



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor clearColor]];
        self.noticeView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 130, 20)];
        [self.noticeView setBackgroundColor:[RCColor RCBlue:1.0f]];
        
        
        UIImage *msgNotify = [UIImage imageNamed:@"msg_notify"];
        UIImageView *notifyImageView = [[UIImageView alloc] initWithImage:msgNotify];
        [notifyImageView setFrame:CGRectMake(8, 1, msgNotify.size.width, msgNotify.size.height)];
        
        [self.noticeView.layer setCornerRadius:10];
        [self.noticeView addSubview:notifyImageView];
        
        UILabel *notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 80, 20)];
        [notifyLabel setTextColor:[UIColor whiteColor]];
        [notifyLabel setTextAlignment:NSTextAlignmentLeft];
        [notifyLabel setFont:[UIFont systemFontOfSize:12]];
        
        notifyLabel.text = @"Julie Smith (2)";
        
        [self.noticeView addSubview:notifyLabel];
        [self.view addSubview:self.noticeView];
        
        [self.noticeView addTarget:self action:@selector(scrollTo) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void) scrollTo
{
    [self.delegate scrollToUnread];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
