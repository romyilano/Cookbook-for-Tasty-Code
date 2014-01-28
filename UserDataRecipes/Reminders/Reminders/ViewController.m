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
    
    // to-do - create and add reminder
    
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
