//
//  MessagesViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesTable.h"

#import "VoiceTable.h"
#import "FaxTable.h"
#import "TextTable.h"
#import "RCColor.h"

@interface MessagesViewController ()

@property (nonatomic) NSInteger *badgeNum;

@property (nonatomic, strong) UIButton *editButton;

@property UISegmentedControl *msgSegments;

@property MessagesTable *msgTable;
@property VoiceTable *voiceTable;
@property FaxTable *faxTable;
@property TextTable *textTable;
@property NSString *selectedTab;


@end

@implementation MessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController.navigationBar setHidden:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    [super loadView];
    self.msgSegments = [[UISegmentedControl alloc] initWithItems:@[@"All",@"Voice",@"Fax",@"Text"]];
    
    [self.msgSegments setFrame:CGRectMake((self.view.bounds.size.width-290.0f)/2, 70.0f, 290.0f, 30.0f)];
    [self.view addSubview:self.msgSegments];
    [self.msgSegments setTintColor:[RCColor RCBlue:1.0f]];
    [self.msgSegments setSelectedSegmentIndex:0];
    [self.msgSegments addTarget:self
                            action:@selector(segmentChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(3, 0, -3, 0)];
    
//    [self.navigationItem.rightBarButtonItem setTintColor:[RCColor RCBlue:1.0F]];

    
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(self.msgSegments.frame.origin.x + 63, 61, 18, 18)];
    [badgeView setBackgroundColor:[RCColor RCBadgeRed:1.0f]];
    badgeView.layer.cornerRadius = 9.0f;
    
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, badgeView.bounds.size.width, badgeView.bounds.size.height)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:14.0f];
    badgeLabel.text = @"2";
    
    [badgeView addSubview:badgeLabel];
    [self.view addSubview:badgeView];
    
    
    UIView *badgeView1 = [[UIView alloc] initWithFrame:CGRectMake(self.msgSegments.frame.origin.x + 208, 61, 18, 18)];
    [badgeView1 setBackgroundColor:[RCColor RCBadgeRed:1.0f]];
    badgeView1.layer.cornerRadius = 9.0f;
    
//    badgeView1.frame = CGRectMake(self.msgSegments.bounds.size.width + 5, 61, 18, 18);
    
    
    UILabel *badgeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, badgeView.bounds.size.width, badgeView.bounds.size.height)];
    badgeLabel1.textColor = [UIColor whiteColor];
    badgeLabel1.textAlignment = NSTextAlignmentCenter;
    badgeLabel1.font = [UIFont systemFontOfSize:14.0f];
    badgeLabel1.text = @"1";

    [badgeView1 addSubview:badgeLabel1];
    
    [self.view addSubview:badgeView1];
    
    UIView *badgeView2 = [[UIView alloc] initWithFrame:CGRectMake(self.msgSegments.frame.origin.x + 278, 61, 18, 18)];
    [badgeView2 setBackgroundColor:[RCColor RCBadgeRed:1.0f]];
    badgeView2.layer.cornerRadius = 9.0f;
    
    UILabel *badgeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, badgeView.bounds.size.width, badgeView.bounds.size.height)];
    badgeLabel2.textColor = [UIColor whiteColor];
    badgeLabel2.textAlignment = NSTextAlignmentCenter;
    badgeLabel2.font = [UIFont systemFontOfSize:14.0f];
    badgeLabel2.text = @"1";
    
    
    [badgeView2 addSubview:badgeLabel2];
    
    [self.view addSubview:badgeView2];
    
    UIView *segmentBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 109.6, self.view.bounds.size.width, 0.6)];
    [segmentBorder setBackgroundColor:[UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.6f]];
    [self.view addSubview:segmentBorder];
    

    self.voiceTable = [[VoiceTable alloc] init];
    
    double tableHeight = self.view.bounds.size.height - self.msgSegments.bounds.size.height - 130;
    CGRect tableRect = CGRectMake(0, 110, self.view.bounds.size.width, tableHeight );
    
    self.voiceTable.view.frame = tableRect ;
    [self.view addSubview:self.voiceTable.view];
    
    [self addChildViewController:self.voiceTable];
    
    
    self.faxTable = [[FaxTable alloc] init];
    
    self.faxTable.view.frame = tableRect;
    [self.view addSubview:self.faxTable.view];
    
    [self addChildViewController:self.faxTable];
    
    
    self.textTable = [[TextTable alloc] init];
    
    self.textTable.view.frame = tableRect;
    [self.view addSubview:self.textTable.view];
    
    [self addChildViewController:self.textTable];
    

    self.msgTable = [[MessagesTable alloc] init];
    
    self.msgTable.view.frame = tableRect;
    [self.view addSubview:self.msgTable.view];
    
    [self addChildViewController:self.msgTable];
    
    [self setSelectedTab:@"All"];
}

-(void) showEditTable{
//    if ([self.selectedTab isEqualToString:@"All"]) {
//        MsgAllEditViewController *allCon = [[MsgAllEditViewController alloc] init];
//        UINavigationController *allNav = [[UINavigationController alloc] initWithRootViewController:allCon];
//        [self presentViewController:allNav animated:NO completion:Nil ];
//    }
//    if ([self.selectedTab isEqualToString:@"Voice"]) {
//        MsgVoiceEditViewController *voiceCon = [[MsgVoiceEditViewController alloc] init];
//        UINavigationController *voiceNav = [[UINavigationController alloc] initWithRootViewController:voiceCon];
//        [self presentViewController:voiceNav animated:NO completion:Nil ];
//    }
//    if ([self.selectedTab isEqualToString:@"Fax"]) {
//        MsgFaxEditViewController *faxCon = [[MsgFaxEditViewController alloc] init];
//        UINavigationController *faxNav = [[UINavigationController alloc] initWithRootViewController:faxCon];
//        [self presentViewController:faxNav animated:NO completion:Nil ];
//    }
//    if ([self.selectedTab isEqualToString:@"Text"]) {
//        MsgTextEditViewController *textCon = [[MsgTextEditViewController alloc] init];
//        UINavigationController *textNav = [[UINavigationController alloc] initWithRootViewController:textCon];
//        [self presentViewController:textNav animated:NO completion:Nil ];
//    }
}
-(void) segmentChanged:(UISegmentedControl *) paramSender{
    
    if ([paramSender isEqual:self.msgSegments]) {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        if ([selectedSegmentText isEqualToString:@"All"]) {
            [self.view bringSubviewToFront:self.msgTable.view];
            [self.delegate didSelectedMessagesTabIndex:0];
            [self setSelectedTab:@"All"];
        }else if([selectedSegmentText isEqualToString:@"Voice"]){
            [self.view bringSubviewToFront:self.voiceTable.view];
            [self.delegate didSelectedMessagesTabIndex:1];
            [self setSelectedTab:@"Voice"];
        }else if([selectedSegmentText isEqualToString:@"Fax"]){
            [self.view bringSubviewToFront:self.faxTable.view];
            [self.delegate didSelectedMessagesTabIndex:2];
            [self setSelectedTab:@"Fax"];
        }else if([selectedSegmentText isEqualToString:@"Text"]){
            [self.view bringSubviewToFront:self.textTable.view];
            [self.delegate didSelectedMessagesTabIndex:3];
            [self setSelectedTab:@"Text"];
        }

    }
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
