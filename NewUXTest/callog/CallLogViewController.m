//
//  CallLogViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "CallLogViewController.h"
#import "CallLogTable.h"
#import "MissedTable.h"
#import "RCColor.h"

@interface CallLogViewController ()

@property UISegmentedControl *calllogSegments;

@property CallLogTable *logTable;
@property MissedTable *missTable;

@end

@implementation CallLogViewController

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
    // Do any additional setup after loading the view

}


- (void)loadView
{
    [super loadView];
    
    self.calllogSegments = [[UISegmentedControl alloc] initWithItems:@[@"All",@"Missed"]];
    
    [self.calllogSegments setFrame:CGRectMake((self.view.bounds.size.width-180.0f)/2, 70.0f, 180.0f, 30.0f)];
    [self.view addSubview:self.calllogSegments];
    [self.calllogSegments setTintColor:[RCColor RCBlue:1.0f]];
    [self.calllogSegments setSelectedSegmentIndex:0];
    [self.calllogSegments addTarget:self
                         action:@selector(segmentChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    
    UIView *segmentBorder = [[UIView alloc] initWithFrame:CGRectMake(0,109.6, self.view.bounds.size.width, 0.6)];
    [segmentBorder setBackgroundColor:[UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.6f]];
    [self.view addSubview:segmentBorder];
    
//    UIImage *contentShoot = [UIImage imageNamed:@"calllog_content"];
//    UIImageView *shootView = [[UIImageView alloc] initWithImage:contentShoot];
//    [shootView setFrame:CGRectMake(0, 50.0f, self.view.bounds.size.width, shootView.bounds.size.height)];
//    [self.view addSubview:shootView];    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(3, 0, -3, 0)];
   
    self.missTable = [[MissedTable alloc] init];
    
    double tableHeight = self.view.bounds.size.height - self.calllogSegments.bounds.size.height - 130;
    CGRect tableRect = CGRectMake(0, 110, self.view.bounds.size.width, tableHeight );
    
    self.missTable.view.frame = tableRect;
    [self.view addSubview:self.missTable.view];
    
    
    [self addChildViewController:self.missTable];
    
    self.logTable = [[CallLogTable alloc] init];
    
    self.logTable.view.frame = tableRect;
    [self.view addSubview:self.logTable.view];
    
    [self addChildViewController:self.logTable];
    

}


-(void) segmentChanged:(UISegmentedControl *) paramSender{
    
    if ([paramSender isEqual:self.calllogSegments]) {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        if ([selectedSegmentText isEqualToString:@"All"]) {
            [self.view bringSubviewToFront:self.logTable.view];
            [self.delegate didSelectedCallLogTabIndex:0];
        }else if([selectedSegmentText isEqualToString:@"Missed"]){
            [self.view bringSubviewToFront:self.missTable.view];
            [self.delegate didSelectedCallLogTabIndex:1];
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
