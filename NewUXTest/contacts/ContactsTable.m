//
//  ContactsTable.m
//  Proto B.1.2
//
//  Created by lamsion.chen on 6/4/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "ContactsTable.h"
#import "RCColor.h"

@interface ContactsTable ()

@end

@implementation ContactsTable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListData" ofType:@"plist"];
    _dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *keyArray = [NSArray arrayWithArray:[_dic allKeys]];
    _keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)]; // 排序
    
    _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _myTable.dataSource = self; // 设置数据源
    _myTable.delegate   = self; // 设置委托
    [self.view addSubview:_myTable];
    
    _myTable.tableHeaderView =  ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
        UIView *searchBar = [[UIView alloc] initWithFrame:CGRectMake(8, 8, self.view.bounds.size.width-26, 32)];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
        searchIcon.frame = CGRectMake((self.view.bounds.size.width - 100)/2 ,(32 - searchIcon.bounds.size.height)/2, searchIcon.image.size.width , searchIcon.image.size.height);
        [searchBar addSubview:searchIcon];
        
        [searchBar.layer setBorderWidth:1.0f];
        [searchBar.layer setBorderColor:[RCColor RCColorRefGray:0.4f]];
        [searchBar.layer setCornerRadius:5.0f];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 70)/2, 0, 60.0f, searchBar.bounds.size.height)];
        [searchLabel setTextAlignment:NSTextAlignmentCenter];
        searchLabel.text = @"Search";
        
        searchLabel.textColor = [RCColor RCTableGray:1.0f];
        searchLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        [searchBar addSubview:searchLabel];
        [view addSubview:searchBar];
        
        view;
    });

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyArray count];
} // 表视图当中存在secion的个数，默认是1个

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *data = [_dic objectForKey:[_keyArray objectAtIndex:section]];
    return [data count];
} // section 中包含row的数量

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义一个静态标识符
    static NSString *cellIdentifier = @"cell";
    // 检查是否限制单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 创建单元格
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // 给cell内容赋值
    
    NSArray *data = [_dic objectForKey:[_keyArray objectAtIndex:indexPath.section]];
    NSString *fontName = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = fontName;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    NSString *string = @"";
    
    for (int i = 0; i < 4; i++)
    {
        NSInteger c = (arc4random() % 10) ; //Random char between ! and z
        string = [string stringByAppendingString:[NSString stringWithFormat: @"%lu", (unsigned long)c]];
    }
    
    cell.detailTextLabel.text = string;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *cellHightLight = [[UIView alloc] init];
    cellHightLight.backgroundColor = [RCColor RCTableHighLight:1.0f];
    cell.selectedBackgroundView = cellHightLight;
    
    return cell;
    
} // 创建单元格

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keyArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keyArray;
} // 返回索引的内容

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"index : %ld title : %@", (long)index, title);
    return index;
} // 选中时，跳转表视图

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
