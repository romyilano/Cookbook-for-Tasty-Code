//
//  AppDelegate.m
//  Retrieving List of Calendars
//
//  Created by Romy Ilano on 12/9/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    /*
     Calendar types an iOS Device can have
     */
    NSArray *calendarTypes = @[@"Local", @"CalDAV", @"Exchange", @"Subscription", @"Birthday"];
    
    // go through calendars one by one
    NSUInteger counter = 1;
    
    for (EKCalendar *thisCalendar in eventStore.calendars)
    {
        // title of the calendar
        NSLog(@"Calendar %lu Title = %@", (unsigned long)counter, thisCalendar.title);
        
        // type of calendar
        NSLog(@"Calendar %lu Type = %@", (unsigned long)counter, [calendarTypes objectAtIndex:thisCalendar.type]);
        
        // color associate with the calendar
        NSLog(@"Calendar %lu Color = %@", (unsigned long)counter, [UIColor colorWithCGColor:thisCalendar.CGColor]);
        
        // whether calendar can be modified or not
        if([thisCalendar allowsContentModifications])
        {
            NSLog(@"Calendar %lu can be modified.", (unsigned long)counter);
            
        } else
        {
            NSLog(@"Calendar %lu cannot be modified", (unsigned long)counter);
        }
        
        counter++;
    }
    
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
