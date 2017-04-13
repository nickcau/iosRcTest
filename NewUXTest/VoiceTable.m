//
//  VoiceTable.m
//  NewUXTest
//
//  Created by 高友健 on 2017/4/12.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import "VoiceTable.h"
#import "RCColor.h"

@interface VoiceTable ()
@property (nonatomic,strong) NSArray *msgContactNames;
@property (nonatomic,strong) NSArray *msgTypes;
@property (nonatomic,strong) NSArray *msgDetails;
@property (nonatomic,strong) NSArray *msgTimes;
@end

@implementation VoiceTable


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Voice" ofType:@"plist"];
    _dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *array = [NSArray arrayWithArray:[_dic allKeys]];
    _keyArray = [array sortedArrayUsingSelector:@selector(compare:)]; // 排序
    
    self.msgContactNames = [_dic objectForKey:[_keyArray objectAtIndex:0]];
    self.msgTypes = [_dic objectForKey:[_keyArray objectAtIndex:1]];
    self.msgDetails = [_dic objectForKey:[_keyArray objectAtIndex:2]];
    self.msgTimes = [_dic objectForKey:[_keyArray objectAtIndex:3]];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 1) {
        
        if ([[self.msgTypes objectAtIndex:indexPath.row] rangeOfString:@"unread"].location != NSNotFound) {
            cell.textLabel.textColor = [RCColor RCBlue:1.0f];
        }else{
            cell.textLabel.textColor = [UIColor colorWithRed:47/255.0f green:47/255.0f blue:47/255.0f alpha:1.0f];
        }
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section ==1) {
        return self.msgTypes.count;
    }
    if (section == 0){
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIView* searchBar = [[UIView alloc] initWithFrame:CGRectMake(8, 8, self.view.bounds.size.width-16, cell.bounds.size.height-12)];
            UIImageView* searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
            
            searchIcon.frame = CGRectMake((cell.bounds.size.width - 100)/2 ,(searchBar.bounds.size.height - searchIcon.bounds.size.height)/2, searchIcon.image.size.width , searchIcon.image.size.height);
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
            
            [cell addSubview:searchBar];

        }
    }
    
    if (indexPath.section == 1) {
        
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [self.msgContactNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.msgDetails objectAtIndex:indexPath.row];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
