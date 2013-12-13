//
//  SLBMapViewController.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/4/13.
//
//

#import "SLBMapViewController.h"
#import "SLBUserInputViewController.h"
#import "Constants.h"

@interface SLBMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *establishmentsArray;
@property (strong, nonatomic) NSString *selectedEstablishment;

@end

@implementation SLBMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // ---- Annotations ----
    PFQuery *query = [PFQuery queryWithClassName:kClassName];
    
    self.establishmentsArray = [query findObjects];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    // create an annotation for each object that was returned
    for (PFObject *object in self.establishmentsArray) {
        MKPointAnnotation *buildingAnnotation = [[MKPointAnnotation alloc] init];
        
        PFGeoPoint *geoPoint = object[kLocation];
        
        CLLocationCoordinate2D buildingCenter = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        [buildingAnnotation setCoordinate:buildingCenter];
        
        [buildingAnnotation setTitle:object[kNameOfEstablishment]];
        
        //calculating the wait time by averaging all of the submitted wait times from users from the past hour
        NSDate *currentDate = [NSDate date];
        NSDate *currentDateAnHourEarlier = [currentDate dateByAddingTimeInterval:-kNumberOfSecondsInMinute*kNumberOfMinutesInHour];
        
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
        
        [buildingAnnotation setSubtitle:[NSString stringWithFormat:@"%@ minutes",object[kWaitTime]]];
        
        [self.mapView addAnnotation:buildingAnnotation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
	// Do any additional setup after loading the view.
    
    // ---- Region ----
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(kLatitudeForStateCollege,kLongitudeForStateCollege);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapCenter, kRegionForMap, kRegionForMap);
    [self.mapView setRegion:region];
    [self.mapView setCenterCoordinate:mapCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView Delegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *myAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationIdentifier"];
    
    //depending on how long the wait time is assign appropriate images/colors to the annotations
    NSString *imageUsed = @"";
    NSLog(@"second length: %d",[self.establishmentsArray count]);
    for (PFObject *object in self.establishmentsArray) {
        if ([object[kNameOfEstablishment] isEqualToString:[myAnnotation.annotation title]]) {
            if ([object[kWaitTime] integerValue] > kLongWait) {
                imageUsed = @"RedDot.png";
            } else if ([object[kWaitTime] integerValue] > kMediumWait) {
                imageUsed = @"YellowDot.png";
            } else {
                imageUsed= @"GreenDot.png";
            }
        }
    }
    
    NSLog(@"annotation: %@",[myAnnotation.annotation title]);
    
    myAnnotation.canShowCallout = YES;
    myAnnotation.image = [UIImage imageNamed:imageUsed];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"arrow.png"];
    customButton.frame = CGRectMake(myAnnotation.rightCalloutAccessoryView.frame.origin.x, myAnnotation.rightCalloutAccessoryView.frame.origin.y, image.size.width, image.size.height);
    [customButton setImage:image forState:UIControlStateNormal];
    myAnnotation.rightCalloutAccessoryView = customButton;
    
    return myAnnotation;
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedEstablishment = [view.annotation title];
    [self performSegueWithIdentifier:@"MapToUserInputSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"MapToUserInputSegue"])
    {
        SLBUserInputViewController *userInputViewController = segue.destinationViewController;
        for (PFObject *dict in self.establishmentsArray) {
            if ([[dict objectForKey:kNameOfEstablishment] isEqualToString:self.selectedEstablishment]) {
                userInputViewController.selectedEstablishment = dict;
            }
        }
    }
}

@end
