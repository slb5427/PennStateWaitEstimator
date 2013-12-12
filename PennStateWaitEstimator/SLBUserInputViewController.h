//
//  SLBUserInputViewController.h
//  PennStateWaitEstimator
//
//  Created by 483W on 12/11/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SLBUserInputViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) PFObject* selectedEstablishment;

@end
