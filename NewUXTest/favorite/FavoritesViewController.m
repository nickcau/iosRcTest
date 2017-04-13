//
//  FavoritesViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesTable.h"
#import "PersonalFavoritesTable.h"
#import "RCColor.h"

@interface FavoritesViewController ()

@property UISegmentedControl *contactSegment;
@property FavoritesTable *favTable;
@property PersonalFavoritesTable *pfavTable;

@end

@implementation FavoritesViewController

@synthesize contactSegment = _contactSegment;
@synthesize favTable = _favTable;
@synthesize pfavTable = _pfavTable;

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
    
    
    
    self.pfavTable = [[PersonalFavoritesTable alloc] init];
    self.pfavTable.view.frame = tableRect;
    
    [self.view addSubview:self.pfavTable.view];
    [self addChildViewController:self.pfavTable];
    
    self.favTable = [[FavoritesTable alloc] init];
    
    self.favTable.view.frame = tableRect;
    [self.view addSubview:self.favTable.view];
    
    [self addChildViewController:self.favTable];

    
    
}

-(void) segmentChanged:(UISegmentedControl *) paramSender{
    
    if ([paramSender isEqual:self.contactSegment]) {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        
        NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        
        if([selectedSegmentText isEqualToString:@"Personal"]){
            [self.view bringSubviewToFront:self.pfavTable.view];
            [self.delegate didSelectedFavoritesTabIndex: 1];
           
        }else{
            [self.view bringSubviewToFront:self.favTable.view];
            [self.delegate didSelectedFavoritesTabIndex: 2];
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
