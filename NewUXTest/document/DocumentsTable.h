//
//  DocumentsTable.h
//  Proto B.1.4
//
//  Created by lamsion.chen on 6/5/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentsTable : UITableViewController

@property (strong, nonatomic) UITableView  *myTable;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray      *keyArray;

@end
