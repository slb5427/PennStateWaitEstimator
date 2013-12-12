//
//  SLBMapViewController.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/4/13.
//
//

#import "SLBMapViewController.h"

@interface SLBMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *establishmentsArray;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // ---- Region ----
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(40.79796,-77.85806);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapCenter, 2100, 2100);
    [self.mapView setRegion:region];
    [self.mapView setCenterCoordinate:mapCenter];
    
    // ---- Annotations ----
    
    PFQuery *query = [PFQuery queryWithClassName:@"Establishment"];
    
    _establishmentsArray = [query findObjects];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    for (PFObject *object in _establishmentsArray) {
        MKPointAnnotation *buildingAnnotation = [[MKPointAnnotation alloc] init];
        PFGeoPoint *geoPoint = object[@"location"];
        
        CLLocationCoordinate2D buildingCenter = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        [buildingAnnotation setCoordinate:buildingCenter];
        
        [buildingAnnotation setTitle:object[@"name"]];
        [buildingAnnotation setSubtitle:[NSString stringWithFormat:@"%@ minutes",object[@"waitTime"]]];
        [self.mapView addAnnotation:buildingAnnotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView Delegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationIdentifier"];
    
    pinAnnotation.animatesDrop = YES;
    pinAnnotation.canShowCallout = YES;
    //pinAnnotation.pinColor = ;
    
    return pinAnnotation;
}
//
//-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    [self performSegueWithIdentifier:@"ImageSegue" sender:nil];
//}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"ImageSegue"])
//    {
//        SLBBuildingInfoViewController *buildingInfoViewController = segue.destinationViewController;
//        
//        buildingInfoViewController.selectedBuilding = self.selectedBuilding;
//        buildingInfoViewController.image = self.image;
//    }
//}

@end
