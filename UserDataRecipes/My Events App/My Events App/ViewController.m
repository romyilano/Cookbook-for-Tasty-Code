//
//  ViewController.m
//  My Events App
//
//  Created by Romy Ilano on 1/27/14.
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
    
    self.eventStore = [[EKEventStore alloc] init];
    
    // Ask user's permission for accessing the calendar
    [self.eventStore requestAccessToEntityType:EKEntityMaskEvent completion:^(BOOL granted, NSError *error) {
        
        if (granted)
        {
            NSDate *now = [NSDate date];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *fortyEightHoursFromNowComponents = [[NSDateComponents alloc] init];
            fortyEightHoursFromNowComponents.day = 2; // 48 hours forward
            
            // "use NSCalendar to help create future date. More accurate than the alternate method (but
            //  not by much) NSDate dateWithTimeIntervalSinceNow:
            NSDate *fortyEightHoursFromNow = [calendar dateByAddingComponents:fortyEightHoursFromNowComponents
                                                                       toDate:now
                                                                      options:0];
            
            
            // Use the predicate to retrieve the actual events from the event store
            NSPredicate *allEventsWithin48HoursPredicate = [self.eventStore predicateForEventsWithStartDate:now endDate:fortyEightHoursFromNow calendars:nil];
            
           
            NSArray *events = [self.eventStore eventsMatchingPredicate:allEventsWithin48HoursPredicate];
            
            for (EKEvent *event in events)
            {
                NSLog(@"%@", event.title);
            }
            
        }
        else
        {
            NSLog(@"Access not granted: %@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
