//
//  SLBTableViewController.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/7/13.
//
//

#import "SLBTableViewController.h"
#import "SLBUserInputViewController.h"
#import "Constants.h"

@interface SLBTableViewController ()

@end

@implementation SLBTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Establishment"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Establishment";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadObjects];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSDictionary *initialUserDefaults = @{kOrderByName:@YES,
                                          kOrderByWaitTime:@NO,
                                          kFilterRestaurants:@YES,
                                          kFilterBars:@YES,
                                          kFilterOther:@YES};
    [preferences registerDefaults:initialUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadObjects];
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    //everytime the data is updated recalculate the wait time
    NSDate *currentDate = [NSDate date];
    NSDate *currentDateAnHourEarlier = [currentDate dateByAddingTimeInterval:-kNumberOfSecondsInMinute*kNumberOfMinutesInHour];
    
    for (PFObject *object in self.objects) {
        NSMutableArray *newTimes = [[NSMutableArray alloc] init];
        
        for(NSDictionary *dict in object[kTimesAlreadySubmitted])
        {
            if ([currentDateAnHourEarlier compare:((NSDate *)[dict objectForKey:kSubmittedTime])] ==NSOrderedAscending) {
                [newTimes addObject:dict];
            }
        }
        
        // estimate wait time
        NSInteger sum = 0;
        for (NSDictionary *dict in newTimes) {
            sum += [[dict objectForKey:kTimeWaited] integerValue];
        }
        NSNumber *newWaitTime = [NSNumber numberWithInteger:0];
        if([newTimes count] != 0)
        {
            newWaitTime = [NSNumber numberWithInteger:sum/[newTimes count]];
        }
        
        object[kTimesAlreadySubmitted] = newTimes;
        object[kWaitTime] = newWaitTime;
        
        [object save];
    }
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    //create predicate based on user preferences
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *filterString = @"";
    if ([[preferences objectForKey:kFilterRestaurants] boolValue]) {
        filterString = @"(isRestaurant = true)";
        if ([[preferences objectForKey:kFilterBars] boolValue]) {
            filterString = [NSString stringWithFormat:@"%@ OR (isBar = true)",filterString];
        }
        if ([[preferences objectForKey:kFilterOther] boolValue]) {
            filterString = [NSString stringWithFormat:@"%@ OR (isRestaurant = false AND isBar = false)",filterString];
        }
    } else if ([[preferences objectForKey:kFilterBars] boolValue]) {
        filterString = @"(isBar = true)";
        if ([[preferences objectForKey:kFilterOther] boolValue]) {
            filterString = [NSString stringWithFormat:@"%@ OR (isRestaurant = false AND isBar = false)",filterString];
        }
    } else {
        filterString = @"(isRestaurant = false AND isBar = false)";
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName predicate:predicate];
    
    if ([[preferences objectForKey:kOrderByName] boolValue]) {
        [query orderByAscending:kNameOfEstablishment];
    } else {
        [query orderByAscending:kWaitTime];
    }
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    if ([object[kWaitTime] integerValue] > kLongWait) {
        CellIdentifier = @"RedCell";
    } else if ([object[kWaitTime] integerValue] > kMediumWait) {
        CellIdentifier = @"YellowCell";
    } else {
        CellIdentifier = @"GreenCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:kNameOfEstablishment];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ minutes", object[kWaitTime]];
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //segue to user input page
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableToUserInputSegue" ]) {
        SLBUserInputViewController *userInputViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        userInputViewController.selectedEstablishment = [self objectAtIndexPath:indexPath];
    } else if ([segue.identifier isEqualToString:@"PreferencesSegue"]) {
        
    }
}



@end
