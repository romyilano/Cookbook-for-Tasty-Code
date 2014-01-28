//
//  ViewController.m
//  Reminders
//
//  Created by Romy Ilano on 1/28/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EKEventStore *)eventStore
{
    if (_eventStore == nil)
    {
        _eventStore = [[EKEventStore alloc] init];
    }
    
    return _eventStore;
}

#pragma mark - Action Methods
-(IBAction)addTimeBasedReminder:(id)sender
{
    [self.activityIndicator startAnimating];
    
    // create and add reminder
    
    // Create the reminder
    EKReminder *newReminder = [EKReminder reminderWithEventStore:self.eventStore];
    newReminder.title = @"Cara beth Burnside is skating";
    newReminder.calendar = [self.eventStore defaultCalendarForNewReminders];
    
    // calculate the date exactly one day from now
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneDayComponents = [[NSDateComponents alloc] init];
    oneDayComponents.day = 1;
    NSDate *nextDay = [calendar dateByAddingComponents:oneDayComponents
                                                toDate:[NSDate date] options:0];
    
    // set the specific time for 6PM - extract the NSDateComponents object
    //  from nextDay, change its hour component to 18 (6pm on a 24 hour clock) and create a new date
    //  from these adjusted components
    NSUInteger unitFlags = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *tomorrowAt6PMComponents = [calendar components:unitFlags fromDate:nextDay];
    tomorrowAt6PMComponents.hour = 18;
    tomorrowAt6PMComponents.minute = 0;
    tomorrowAt6PMComponents.second = 0;
    NSDate *nextDayAt6PM = [calendar dateFromComponents:tomorrowAt6PMComponents];
    
    // create an EKAlaram with the time and add it to the reminder
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:nextDayAt6PM];
    [newReminder addAlarm:alarm];
    newReminder.dueDateComponents = tomorrowAt6PMComponents;
    
    // save reminder
    NSString *alertTitle = [[NSString alloc] init];
    NSString *alertMessage = [[NSString alloc] init];
    NSString *alertButtonTitle = [[NSString alloc] init];
    NSError *error = nil;
    
    [self.eventStore saveReminder:newReminder
                           commit:YES error:&error];
    
    if (error == nil)
    {
        alertTitle = @"Information";
        alertMessage = [NSString stringWithFormat:@"\"%@\" was added to Reminders", newReminder.title];
        alertButtonTitle = @"OK";
    }
    else
    {
        alertTitle = @"Error";
        alertMessage = [NSString stringWithFormat:@"Unable to save reminder: %@", error];
        alertButtonTitle = @"Dismiss";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMessage
                                                           delegate:nil
                                                  cancelButtonTitle:alertButtonTitle
                                                  otherButtonTitles: nil];
        [alertView show];
        [self.activityIndicator stopAnimating];
    });
    
    
    
    // grabbing the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // to-do notify the user if the reminder was successfully added or not
        [self.activityIndicator stopAnimating];
    });
    
}

-(IBAction)addLocationBasedReminder:(id)sender
{
    
}

#pragma mark - Custom Method
-(void)handleReminderAction:(RestrictedEventStoreActionHandler)block
{
        [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                        completion:^(BOOL granted, NSError *error) {
                                            
                                            if (granted)
                                            {
                                                block();
                                            }
                                            else
                                            {
                                                UIAlertView *notGrantedAlert = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                                                          message:@"Access to device's reminders has been denied for this app"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"OK'" otherButtonTitles: nil];
                                                
                                                // throws the alert back to the main thread since it's
                                                //  UI
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [notGrantedAlert show];
                                                });
                                            }
                                        }];
}

@end
