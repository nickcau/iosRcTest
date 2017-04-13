//
//  DialPadViewController.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/22/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "DialPadViewController.h"
#import "RCColor.h"
#import "DialNumber.h"

@interface DialPadViewController ()

@property UILabel *fromLabel;


@end

@implementation DialPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//         self.navigationItem.title = @"Keypad";
    }
    if (arrayOfItems == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DialNumbers" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableArray *sampleData = [[dict valueForKey:@"Nums"] mutableCopy];
        NSRange rangeOne = NSMakeRange(0, 13);
        
        arrayOfItems = [[sampleData objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeOne]] mutableCopy];
    }
    
    return self;
}

- (void) popVC{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    CGFloat numberHeight = (self.view.bounds.size.height/568) * 40;
    CGFloat currentWidth = 320 + (self.view.bounds.size.width - 320)*.5;
    CGFloat leftOrign = (self.view.bounds.size.width - currentWidth)/2;
    
//    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, numberHeight)];
//    [number setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:38]];
//    number.text = @"(650) 394-7";
//    [number setTextColor:[UIColor blackColor]];
//    [number setTextAlignment:NSTextAlignmentCenter];
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:number.text];
//    
//    float spacing = 1.6f;
//    [attributedString addAttribute:NSKernAttributeName
//                             value:@(spacing)
//                             range:NSMakeRange(0, [number.text length])];
//    
//    number.attributedText = attributedString;
//    [number setAlpha:0.7];
    
    UIView *fromView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+leftOrign, numberHeight+20, 150, 50)];
    UILabel *fromNumber = [[UILabel alloc] initWithFrame:CGRectMake(55+leftOrign, numberHeight+20,200, 50)];
    [_fromLabel setTextColor:[UIColor lightGrayColor]];
    [fromNumber setTextColor:[UIColor blackColor]];
    [_fromLabel setText:@"From:"];
    [fromNumber setText:@"(650) 394-7510"];
    [_fromLabel setFont:[UIFont systemFontOfSize:12]];
    [fromNumber setFont:[UIFont systemFontOfSize:14]];
    [fromNumber setAlpha:0.7];
    
    UIImage *arrowImg = [UIImage imageNamed:@"icon_chevron_down"];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
    [arrow setFrame:CGRectMake(160+leftOrign, numberHeight+35, arrowImg.size.width -5, arrowImg.size.height-5)];


    
//    [self.view addSubview:number];
    [fromView addSubview:_fromLabel];
    [fromView addSubview:fromNumber];
    [fromView addSubview:arrow];
    [fromView setCenter:CGPointMake(self.view.bounds.size.width/2, 15)];
    [self.view addSubview:fromView];
    
    [self loadDialNumbers];
}

- (void)cancel
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadDialNumbers
{
    CGFloat numberHeight = (self.view.bounds.size.height/568) * 40;
    CGFloat currentWidth = 320 + (self.view.bounds.size.width - 320)*.5;
    CGFloat leftOrign = (self.view.bounds.size.width - currentWidth)/2;
    
    CGFloat orignX = leftOrign + 30;
    CGFloat orignY = numberHeight + 5+ 50*(1+(self.view.bounds.size.width - 320)/320);
    
    CGFloat dialPadWidth = self.view.bounds.size.width - 2*orignX;
    
    CGFloat numberSize = 75*(1+0.25*(self.view.bounds.size.width - 320)/320);
    
    CGFloat dialPadHeight = self.view.bounds.size.height - orignY - 50;
    
//    CGFloat numberHeight = self.view.bounds.size.height - _fromLabel.frame.origin.y - 20*(self.view.bounds.size.width/320);
    
    CGFloat paddingX = numberSize+ (dialPadWidth - numberSize*3)/2;
    
    CGFloat paddingY = numberSize+ (dialPadHeight - numberSize*5.2 - 80*(self.view.bounds.size.width - 320)/320)/4;
    
    for (int i=1; i<14; i++) {
        NSArray *num = [arrayOfItems objectAtIndex:(i-1)];

        DialNumber *dial = [[DialNumber alloc] initDialNumber:[num objectAtIndex:0] withSub:[num objectAtIndex:1] withSize:numberSize];
        [dial setFrame:CGRectMake(orignX, orignY, dial.bounds.size.width, dial.bounds.size.height)];
        if (i==13) {
            [dial setCenter:CGPointMake(self.view.bounds.size.width/2, dial.frame.origin.y+dial.frame.size.height/2 + 4)];
        }
        [self.view addSubview:dial];
        orignX += paddingX;
        if ((i%3) == 0) {
            orignX = leftOrign + 30;
            orignY += paddingY;
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
