//
//  DraftTable.m
//  Proto B.4.1
//
//  Created by lamsion.chen on 6/13/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "DraftTable.h"
#import "RCColor.h"

@interface DraftTable ()

@property (nonatomic,strong) NSArray *msgContactNames;
@property (nonatomic,strong) NSArray *msgTypes;
@property (nonatomic,strong) NSArray *msgTimes;

@end

@implementation DraftTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)loadView
{
    [super loadView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Draft" ofType:@"plist"];
    _dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *array = [NSArray arrayWithArray:[_dic allKeys]];
    _keyArray = [array sortedArrayUsingSelector:@selector(compare:)]; // 排序
    
    self.msgContactNames = [_dic objectForKey:[_keyArray objectAtIndex:0]];
    self.msgTypes = [_dic objectForKey:[_keyArray objectAtIndex:1]];
    self.msgTimes = [_dic objectForKey:[_keyArray objectAtIndex:2]];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark -
#pragma mark UITableView Delegate


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        
       
        cell.textLabel.textColor = [UIColor colorWithRed:47/255.0f green:47/255.0f blue:47/255.0f alpha:1.0f];
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        cell.detailTextLabel.textColor = [RCColor RCTableGray:1.0f];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //here is a iOS 7 bug!
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    if ( sectionIndex ==0) {
        NSArray *msgContactNames = [_dic objectForKey:[_keyArray objectAtIndex:1]];
        return msgContactNames.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    
    /*
     get data source from plist file
     */
    
    if (indexPath.section == 0) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [self.msgContactNames objectAtIndex:indexPath.row];
       
        cell.imageView.image = [UIImage imageNamed:[self.msgTypes objectAtIndex:indexPath.row]];
        
        UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80.0f, cell.bounds.size.height)];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, cell.bounds.size.height)];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        timeLabel.text = [self.msgTimes objectAtIndex:indexPath.row];
        
        timeLabel.textColor = [RCColor RCTableGray:1.0f];
        timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        
        UIImageView *accImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chevron_normal"]];
        accImage.frame = CGRectMake(65, ((cell.bounds.size.height - accImage.image.size.height)/2), accImage.image.size.width, accImage.image.size.height);
        
        [accView addSubview:timeLabel];
        [accView addSubview:accImage];
        [cell setAccessoryView:accView];
    }
    
    
    UIView *cellHightLight = [[UIView alloc] init];
    cellHightLight.backgroundColor = [RCColor RCTableHighLight:1.0f];
    cell.selectedBackgroundView = cellHightLight;
    
    return cell;
}

@end


