//
//  DocumentsViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentsTable.h"
#import "OutboxTable.h"
#import "DraftTable.h"
#import "RCColor.h"

@interface DocumentsViewController ()

@property UISegmentedControl *docSegments;
@property DocumentsTable *docTable;
@property DraftTable *draftTable;
@property OutboxTable *outboxTable;

@end

@implementation DocumentsViewController

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
    self.docSegments = [[UISegmentedControl alloc] initWithItems:@[@"Documents",@"Drafts",@"Outbox"]];
    
    [self.docSegments setFrame:CGRectMake((self.view.bounds.size.width-250.0f)/2, 70.0f, 250.0f, 30.0f)];
    [self.view addSubview:self.docSegments];
    [self.docSegments setTintColor:[RCColor RCBlue:1.0f]];
    [self.docSegments setSelectedSegmentIndex:0];
    [self.docSegments addTarget:self
                         action:@selector(segmentChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    
    UIView *segmentBorder = [[UIView alloc] initWithFrame:CGRectMake(0,109.6, self.view.bounds.size.width, 0.6)];
    [segmentBorder setBackgroundColor:[UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.6f]];
    [self.view addSubview:segmentBorder];
    
    self.draftTable = [[DraftTable alloc] init];
    
    double tableHeight = self.view.bounds.size.height - self.docSegments.bounds.size.height - 130;
    CGRect tableRect = CGRectMake(0, 110, self.view.bounds.size.width, tableHeight );
    
    self.draftTable.view.frame = tableRect;
    
    [self.view addSubview:self.draftTable.view];
    
    [self addChildViewController:self.draftTable];
    
    
    self.outboxTable = [[OutboxTable alloc] init];
    
    self.outboxTable.view.frame = tableRect;
    
    [self.view addSubview:self.outboxTable.view];
    
    [self addChildViewController:self.outboxTable];
    
    
    self.docTable = [[DocumentsTable alloc] init];
    
    self.docTable.view.frame = tableRect;
    
    [self.view addSubview:self.docTable.view];
    
    [self addChildViewController:self.docTable];
    
    
    UIView *badgeView2 = [[UIView alloc] initWithFrame:CGRectMake(self.docSegments.bounds.size.width + (self.view.bounds.size.width-250.0f)/2 - 10, 61, 18, 18)];
    [badgeView2 setBackgroundColor:[RCColor RCBadgeRed:1.0f]];
    badgeView2.layer.cornerRadius = 9.0f;
    
    UILabel *badgeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, badgeView2.bounds.size.width, badgeView2.bounds.size.height)];
    badgeLabel2.textColor = [UIColor whiteColor];
    badgeLabel2.textAlignment = NSTextAlignmentCenter;
    badgeLabel2.font = [UIFont systemFontOfSize:14.0f];
    badgeLabel2.text = @"4";
    
    
    [badgeView2 addSubview:badgeLabel2];
    
    [self.view addSubview:badgeView2];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) segmentChanged:(UISegmentedControl *) paramSender{
    
    if ([paramSender isEqual:self.docSegments]) {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        
        NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        
        if ([selectedSegmentText isEqualToString:@"Documents"]) {
            [self.view bringSubviewToFront:self.docTable.view];
            [self.delegate didSelectedDocumentsTabIndex:0];
        }else if([selectedSegmentText isEqualToString:@"Drafts"]){
            [self.view bringSubviewToFront:self.draftTable.view];
            [self.delegate didSelectedDocumentsTabIndex:1];
        }else{
            [self.view bringSubviewToFront:self.outboxTable.view];
            [self.delegate didSelectedDocumentsTabIndex:2];
        }
    }
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
