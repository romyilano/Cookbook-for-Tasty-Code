//
//  ViewController.h
//  Reminders
//
//  Created by Romy Ilano on 1/28/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>

//
typedef void(^RestrictedEventStoreActionHandler)();

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) EKEventStore *eventStore;

-(IBAction)addTimeBasedReminder:(id)sender;
-(IBAction)addLocationBasedReminder:(id)sender;

// mission of this method is to request access to Reminders and invoke the provided block
//      of code granted. If access is denied, it simply displays an alert to inform the user.
-(void)handleReminderAction:(RestrictedEventStoreActionHandler)block;

@end
