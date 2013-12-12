//
//  SLBUserInputViewController.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/11/13.
//
//

#import "SLBUserInputViewController.h"
#import "Constants.h"

@interface SLBUserInputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *waitTimeTextField;
- (IBAction)submitUserInput:(id)sender;

@end

@implementation SLBUserInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)submitUserInput:(id)sender {
    //valid data that is in the text field, make sure only integer
    
    //add time to the times array and re-evaluate the wait time by using only the times that have occured in the last hour
    NSNumber *waitTime = [NSNumber numberWithInteger:[self.waitTimeTextField.text integerValue]];
    NSDate *currentDate = [NSDate date];
    
    NSDictionary *dictionary = @{kTimeWaited:waitTime,
                                 kSubmittedTime:currentDate};
    
    PFQuery *query = [PFQuery queryWithClassName:kClassName];
    
    NSDate *currentDateAnHourEarlier = [currentDate dateByAddingTimeInterval:-kNumberOfSecondsInMinute*kNumberOfMinutesInHour];
    
    // Retrieve the object by id
    
    PFObject *establishment = [query getObjectWithId:self.selectedEstablishment.objectId];
    NSMutableArray *newTimes = [[NSMutableArray alloc] init];
        
    for(NSDictionary *dict in establishment[kTimesAlreadySubmitted])
    {
        if ([currentDateAnHourEarlier compare:((NSDate *)[dict objectForKey:kSubmittedTime])] ==NSOrderedAscending) {
            [newTimes addObject:dict];
        }
    }
    // add new data to the times that will be used to calculate the wait time
    [newTimes addObject:dictionary];
    
    // estimate wait time
    NSInteger sum = 0;
    for (NSDictionary *dict in newTimes) {
        sum += [[dict objectForKey:kTimeWaited] integerValue];
    }
    NSNumber *newWaitTime = [NSNumber numberWithInteger:sum/[newTimes count]];
    
    establishment[kTimesAlreadySubmitted] = newTimes;
    establishment[kWaitTime] = newWaitTime;
        
    [establishment save];
     
    
    //pop the view to return to which ever view they came from
    [self.navigationController popViewControllerAnimated:YES];
}
@end
