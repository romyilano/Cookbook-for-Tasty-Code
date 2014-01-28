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

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) EKEventStore *eventStore;

-(IBAction)addTimeBasedReminder:(id)sender;
-(IBAction)addLocationBasedRemidner:(id)sender;

@end
