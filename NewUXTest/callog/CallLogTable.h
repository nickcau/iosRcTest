//
//  CallLogTable.h
//  Proto B.1.2
//
//  Created by lamsion.chen on 6/4/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallLogTable : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView  *myTable;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray      *keyArray;

@end