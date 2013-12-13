//
//  SLBPreferencesViewController.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/12/13.
//
//

#import "SLBPreferencesViewController.h"
#import "Constants.h"

@interface SLBPreferencesViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *nameSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *waitTimeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *restaurantsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *barsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *otherSwitch;
- (IBAction)orderByName:(id)sender;
- (IBAction)orderByWaitTime:(id)sender;
- (IBAction)filterRestaurants:(id)sender;
- (IBAction)filterBars:(id)sender;
- (IBAction)filterOther:(id)sender;


@end

@implementation SLBPreferencesViewController

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
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    self.nameSwitch.on = [[preferences objectForKey:kOrderByName] boolValue];
    self.waitTimeSwitch.on = [[preferences objectForKey:kOrderByWaitTime] boolValue];
    self.restaurantsSwitch.on = [[preferences objectForKey:kFilterRestaurants] boolValue];
    self.barsSwitch.on = [[preferences objectForKey:kFilterBars] boolValue];
    self.otherSwitch.on = [[preferences objectForKey:kFilterOther] boolValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)orderByName:(id)sender {
    [self.waitTimeSwitch setOn:![self.nameSwitch isOn] animated:YES];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:self.nameSwitch.on forKey:kOrderByName];
    [preferences setBool:self.waitTimeSwitch.on forKey:kOrderByWaitTime];
    [preferences synchronize];
}

- (IBAction)orderByWaitTime:(id)sender {
    [self.nameSwitch setOn:![self.waitTimeSwitch isOn] animated:YES];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:self.nameSwitch.on forKey:kOrderByName];
    [preferences setBool:self.waitTimeSwitch.on forKey:kOrderByWaitTime];
    [preferences synchronize];
}

//At least one

- (IBAction)filterRestaurants:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!self.barsSwitch.on && !self.otherSwitch.on) {
        [self.restaurantsSwitch setOn:YES animated:YES];
    }
    [preferences setBool:self.restaurantsSwitch.on forKey:kFilterRestaurants];
    [preferences synchronize];
}

- (IBAction)filterBars:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!self.restaurantsSwitch.on && !self.otherSwitch.on) {
        [self.barsSwitch setOn:YES animated:YES];
    }
    [preferences setBool:self.barsSwitch.on forKey:kFilterBars];
    [preferences synchronize];
}

- (IBAction)filterOther:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!self.barsSwitch.on && !self.restaurantsSwitch.on) {
        [self.otherSwitch setOn:YES animated:YES];
    }
    [preferences setBool:self.otherSwitch.on forKey:kFilterOther];
    [preferences synchronize];
}

@end
