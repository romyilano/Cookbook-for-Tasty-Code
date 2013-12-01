//
//  ViewController.m
//  GCD - UI-Related Tasks
//
//  Created by Romy Ilano on 12/1/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.simpleCountingBlock = ^{
        
        // this is nice, it shows the threads
        NSUInteger counter = 0;
        for (counter = 1; counter <= 1000; counter++)
        {
            NSLog(@"Counter = %lu - Thread = %@",
                  (unsigned long)counter,
                  [NSThread currentThread]);
        }
    };
    
    // invoke the block object using GCD
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_sync(concurrentQueue, self.simpleCountingBlock);
    dispatch_sync(concurrentQueue, self.simpleCountingBlock);
    
    /*
     
     Vandipoor - it's weird, the counting takes place on the main thread
     even though you've asked a concurrent queue to execute the task.
     This is an optimization by GCD
     dispatch_sync function will use the current hread (using when you dispatch the
     task) whenever possible
     
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
