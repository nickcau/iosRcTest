//
//  VoiceTable.h
//  NewUXTest
//
//  Created by 高友健 on 2017/4/12.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceTable : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView  *myTable;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray      *keyArray;

@end
