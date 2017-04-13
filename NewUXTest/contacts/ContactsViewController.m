//
//  ContactsViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTable.h"
#import "PersonalTable.h"
#import "RCColor.h"

@interface ContactsViewController ()

@property UISegmentedControl *contactSegment;
@property ContactsTable *contactsTable;
@property PersonalTable *personalTable;

@end

@implementation ContactsViewController

@synthesize contactSegment = _contactSegment;
@synthesize contactsTable = _contactsTable;
@synthesize personalTable = _personalTable;

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
    
    self.navigationItem.rightBarButtonItem.tintColor = [RCColor RCOrange:1.0f];
    self.contactSegment = [[UISegmentedControl alloc] initWithItems:@[@"Personal",@"Company"]];
    
    [self.contactSegment setFrame:CGRectMake((self.view.bounds.size.width-180.0f)/2, 70.0f, 180.0f, 30.0f)];
    [self.view addSubview:self.contactSegment];
    [self.contactSegment setTintColor:[RCColor RCBlue:1.0f]];
    [self.contactSegment setSelectedSegmentIndex:1];
    
    [self.contactSegment addTarget:self
                            action:@selector(segmentChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    
//    UIImage *contentShoot = [UIImage imageNamed:@"contacts_content"];
//    UIImageView *shootView = [[UIImageView alloc] initWithImage:contentShoot];
//    [shootView setFrame:CGRectMake(0, 50.0f, self.view.bounds.size.width, shootView.bounds.size.height)];
//    [self.view addSubview:shootView];

    UIView *segmentBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 109.6, self.view.bounds.size.width, 0.6)];
    [segmentBorder setBackgroundColor:[UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.6f]];
    [self.view addSubview:segmentBorder];
    
    double tableHeight = self.view.bounds.size.height - self.contactSegment.bounds.size.height - 12;
    CGRect tableRect = CGRectMake(0, 110, self.view.bounds.size.width, tableHeight );

    
    
    self.personalTable = [[PersonalTable alloc] init];
    self.personalTable.view.frame = tableRect;
    
    [self.view addSubview:self.personalTable.view];
    [self addChildViewController:self.personalTable];
    
    self.contactsTable = [[ContactsTable alloc] init];
    
    self.contactsTable.view.frame = tableRect;
    [self.view addSubview:self.contactsTable.view];
    
    [self addChildViewController:self.contactsTable];

    

}

-(void) segmentChanged:(UISegmentedControl *) paramSender{
    
    if ([paramSender isEqual:self.contactSegment]) {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        
        NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        
       if([selectedSegmentText isEqualToString:@"Personal"]){
            [self.view bringSubviewToFront:self.personalTable.view];
            [self.delegate didSelectedContactsTabIndex: 1];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown_menu_normal"] style:UIBarButtonItemStylePlain target:self action:nil];
//            self.navigationItem.rightBarButtonItem.tintColor = [RCColor RCOrange:1.0f];
        }else{
            [self.view bringSubviewToFront:self.contactsTable.view];
            [self.delegate didSelectedContactsTabIndex: 2];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:nil];
//            [self.navigationItem.rightBarButtonItem setTintColor:[RCColor RCBlue:1.0f]];
        }
    }
}

- (void)showFilters
{
    
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
