//
//  Constants.m
//  PennStateWaitEstimator
//
//  Created by 483W on 12/11/13.
//
//

#import "Constants.h"

@implementation Constants

NSInteger const kNumberOfMinutesInHour = 60;
NSInteger const kNumberOfSecondsInMinute = 60;
NSInteger const kRegionForMap = 2100;
NSInteger const kLongWait = 30;
NSInteger const kMediumWait = 10;

CGFloat const kLatitudeForStateCollege = 40.79796;
CGFloat const kLongitudeForStateCollege = -77.85806;

NSString * const kClassName = @"Establishment";
NSString * const kTimeWaited = @"time";
NSString * const kSubmittedTime = @"submitted";
NSString * const kTimesAlreadySubmitted = @"times";
NSString * const kWaitTime = @"waitTime";
NSString * const kNameOfEstablishment = @"name";
NSString * const kLocation = @"location";

NSString * const kOrderByName = @"orderByName";
NSString * const kOrderByWaitTime = @"orderByWaitTime";
NSString * const kFilterRestaurants = @"filterRestaurants";
NSString * const kFilterBars = @"filterBars";
NSString * const kFilterOther = @"filterOther";

NSString * const kIsRestaurant = @"isRestaurant";
NSString * const kIsBar = @"isBar";

@end
