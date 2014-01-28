//
//  ViewController.h
//  My Events App
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ViewController : UIViewController

/*
 
 "Whenever you're dealing with the Event Kit Framework, the main element you work with is an EKEventStore. This class allows you to access, delete, and save events in your calendars. An EKEventStore takes a relatively long time to initialize, so you should only do it once and store it in a property.
 */

@property (strong, nonatomic) EKEventStore *eventStore;


@end
