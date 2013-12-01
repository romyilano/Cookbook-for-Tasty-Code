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
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // sample 1 - download logo from web and display it on the main thread
    [self logoDownload];
    
    // sample 2
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
