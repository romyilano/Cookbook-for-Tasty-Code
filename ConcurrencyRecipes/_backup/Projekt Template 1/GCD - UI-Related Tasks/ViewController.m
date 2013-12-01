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
    
    // grab a main queue
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(mainQueue, ^{
        
        // do main thread stuff here
        // do UI work here
        [[[UIAlertView alloc] initWithTitle:@"Noisebridge"
                                    message:@"Noisebridge is excellent!"
                                   delegate:nil
                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
