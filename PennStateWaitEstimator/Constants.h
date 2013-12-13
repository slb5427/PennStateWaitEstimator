//
//  Constants.h
//  PennStateWaitEstimator
//
//  Created by 483W on 12/11/13.
//
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

FOUNDATION_EXPORT NSInteger const kNumberOfMinutesInHour;
FOUNDATION_EXPORT NSInteger const kNumberOfSecondsInMinute;
FOUNDATION_EXPORT NSInteger const kRegionForMap;
FOUNDATION_EXPORT NSInteger const kLongWait;
FOUNDATION_EXPORT NSInteger const kMediumWait;

FOUNDATION_EXPORT CGFloat const kLatitudeForStateCollege;
FOUNDATION_EXPORT CGFloat const kLongitudeForStateCollege;

FOUNDATION_EXPORT NSString * const kClassName;
FOUNDATION_EXPORT NSString * const kTimeWaited;;
FOUNDATION_EXPORT NSString * const kSubmittedTime;
FOUNDATION_EXPORT NSString * const kTimesAlreadySubmitted;
FOUNDATION_EXPORT NSString * const kWaitTime;
FOUNDATION_EXPORT NSString * const kNameOfEstablishment;
FOUNDATION_EXPORT NSString * const kLocation;

FOUNDATION_EXPORT NSString * const kOrderByName;
FOUNDATION_EXPORT NSString * const kOrderByWaitTime;
FOUNDATION_EXPORT NSString * const kFilterRestaurants;
FOUNDATION_EXPORT NSString * const kFilterBars;
FOUNDATION_EXPORT NSString * const kFilterOther;

FOUNDATION_EXPORT NSString * const kIsRestaurant;
FOUNDATION_EXPORT NSString * const kIsBar;

@end
