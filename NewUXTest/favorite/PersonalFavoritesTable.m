//
//  PersonalFavoritesTable.m
//  Proto B.1.4
//
//  Created by lamsion.chen on 6/5/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "PersonalFavoritesTable.h"
#import "RCColor.h"

@interface PersonalFavoritesTable ()
@property (nonatomic) NSIndexPath *expandingIndexPath;
@property (nonatomic) NSIndexPath *expandedIndexPath;

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PersonalFavoritesTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.title = @"Reordering";
	
	/*
     Populate array.
	 */
	if (arrayOfItems == nil) {
		
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PFavorites" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableArray *sampleData = [[dict valueForKey:@"Fav"] mutableCopy];
        NSRange rangeOne = NSMakeRange(0, 8);
        
       arrayOfItems = [[sampleData objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeOne]] mutableCopy];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView flashScrollIndicators];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
	 */
	[self setReorderingEnabled:( arrayOfItems.count > 1 )];
	if (self.expandedIndexPath) {
		return [arrayOfItems count] + 1;
	}
	return [arrayOfItems count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:47/255.0f green:47/255.0f blue:47/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    cell.detailTextLabel.textColor = [RCColor RCTableGray:1.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = nil;
    
    if ([indexPath isEqual:self.expandedIndexPath]) {
		cellIdentifier = @"ExpandedCellIdentifier";
	}
    // init expanding cell
	else {
		cellIdentifier = @"ExpandingCellIdentifier";
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"ExpandedCellIdentifier"]) {
        UIImage *callImg = [UIImage imageNamed:@"phone"];
        UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 50, 50)];
        [callButton setImage:callImg forState:UIControlStateNormal];
        [cell addSubview:callButton];
        
        UIImage *msgImg = [UIImage imageNamed:@"icon_messages_pressed"];
        UIButton *msgButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 50, 50)];
        [msgButton setImage:msgImg forState:UIControlStateNormal];
        [cell addSubview:msgButton];
        
        UIImage *faxImg = [UIImage imageNamed:@"icon_fax_pressed"];
        UIButton *faxButton = [[UIButton alloc] initWithFrame:CGRectMake(165, 0, 50, 50)];
        [faxButton setImage:faxImg forState:UIControlStateNormal];
        [cell addSubview:faxButton];
        
        UIImage *favImg = [UIImage imageNamed:@"Favorites_selected"];
        UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 0, 50, 50)];
        [favButton setImage:favImg forState:UIControlStateNormal];
        [cell addSubview:favButton];
        
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"ExpandingCellIdentifier"]) {
		NSIndexPath *theIndexPath = [self actualIndexPathForTappedIndexPath:indexPath];
		[cell.textLabel setText:[[arrayOfItems objectAtIndex:[theIndexPath row]] objectAtIndex:1]];
        
        UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90.0f, 0, 80.0f, cell.bounds.size.height)];
        
        UIImageView *callImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_call"]];
        callImage.frame = CGRectMake(60, ((cell.bounds.size.height - callImage.image.size.height)/2), callImage.image.size.width, callImage.image.size.height);
        
        UIImageView *textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_text"]];
        textImage.frame = CGRectMake(20, ((cell.bounds.size.height - textImage.image.size.height)/2), textImage.image.size.width, textImage.image.size.height);
        
        [accView addSubview:callImage];
        [accView addSubview:textImage];
        
        
        NSArray *movie = [arrayOfItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [movie objectAtIndex:1];
        cell.detailTextLabel.text = [movie objectAtIndex:2];
//        cell.imageView.image = [UIImage imageNamed:[movie objectAtIndex:0]];
        
        [cell setAccessoryView:accView];

	}
   
    
    UIView *cellHightLight = [[UIView alloc] init];
    cellHightLight.backgroundColor = [RCColor RCTableHighLight:1.0f];
    cell.selectedBackgroundView = cellHightLight;

	
    return cell;
}

// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController {
	
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90.0f, 0, 80.0f, cell.bounds.size.height)];
    
    UIImageView *callImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_call"]];
    callImage.frame = CGRectMake(60, ((cell.bounds.size.height - callImage.image.size.height)/2), callImage.image.size.width, callImage.image.size.height);
    
    UIImageView *textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_text"]];
    textImage.frame = CGRectMake(20, ((cell.bounds.size.height - textImage.image.size.height)/2), textImage.image.size.width, textImage.image.size.height);
    
    [accView addSubview:callImage];
    [accView addSubview:textImage];

    
    
    NSArray *movie = [arrayOfItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [movie objectAtIndex:1];
    cell.detailTextLabel.text = [movie objectAtIndex:2];
//    cell.imageView.image = [UIImage imageNamed:[movie objectAtIndex:0]];
    
    [cell setAccessoryView:accView];
    
    UIView *cellHightLight = [[UIView alloc] init];
    cellHightLight.backgroundColor = [RCColor RCTableHighLight:1.0f];
    cell.selectedBackgroundView = cellHightLight;

	
    return cell;

}

/*
 Required for drag tableview controller
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSArray *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
	[arrayOfItems removeObjectAtIndex:fromIndexPath.row];
	[arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
	
    // deselect row
	[tableView deselectRowAtIndexPath:indexPath
							 animated:NO];
	
}

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath
{
	if (self.expandedIndexPath && [indexPath row] > [self.expandedIndexPath row]) {
		return [NSIndexPath indexPathForRow:[indexPath row] - 1
								  inSection:[indexPath section]];
	}
	
	return indexPath;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

@end
