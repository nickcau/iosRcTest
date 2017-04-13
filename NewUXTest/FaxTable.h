//
//  FaxTable.h
//  Proto B.3.0
//
//  Created by lamsion.chen on 6/10/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaxTable : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView  *myTable;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray      *keyArray;

@end
