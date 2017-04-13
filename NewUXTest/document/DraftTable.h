//
//  DraftTable.h
//  Proto B.4.1
//
//  Created by lamsion.chen on 6/13/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftTable : UITableViewController

@property (strong, nonatomic) UITableView  *myTable;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray      *keyArray;

@end
