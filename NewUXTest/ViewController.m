//
//  ViewController.m
//  NewUXTest
//
//  Created by 高友健 on 2017/4/8.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(300, 300,200, 200);
//    button.titleLabel.text = @"pressme";
//    [button addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    self.navigationItem.title = @"我的应用";
    UIBarButtonItem *barbtn= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.rightBarButtonItem = barbtn;
    UIImage* image = [UIImage imageNamed:@"22.jpg"];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 320, 568)];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.image = image;
    [self.view addSubview:imgView];
    
}


-(void)searchprogram{
    NSLog(@"press me");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
