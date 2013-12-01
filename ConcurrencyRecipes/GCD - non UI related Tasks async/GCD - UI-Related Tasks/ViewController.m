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
    
    // grab a reference to a concurrent queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // launch the concurrent queue and download the image
    dispatch_async(concurrentQueue, ^{
        
        // __block ensures the pointer data is accessible to the block
        __block UIImage *noisebridgeLogo = nil;
        
        dispatch_sync(concurrentQueue, ^{
            
            // download the image here
            
            // Noisebridge logo
            NSString *urlAsString = @"http://hackerspaces.org/images/c/cf/Noisebridge-on-metalab.png";
            NSURL *url = [NSURL URLWithString:urlAsString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            NSError *downloadError = nil;
            
            // note that we're using sendSynchronousRequest:
            // since it's synchronous as a request it's going to block the concurrentQueue
            // which is not the main queue
            NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                      returningResponse:nil
                                                                  error:&downloadError];
            
        
            if (downloadError == nil && imageData != nil)     // SUCCESS
            {
                noisebridgeLogo = [UIImage imageWithData:imageData];
            }
            else if (downloadError != nil)
            {
                NSLog(@"Error happened = %@", downloadError);
            } else
            {
                NSLog(@"No data could get downloaded from the URL");
            }
        });
        
        // return back to the mothership (main queue)
        // return that image
        dispatch_sync(dispatch_get_main_queue(), ^{
           
            if (noisebridgeLogo != nil) {
                // create image view here
                [self.imageView setImage:noisebridgeLogo];
                
                // make sure the image is scaled properly
                [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
            }
            else
            {
                NSLog(@"Image isn't downloaded. Nothing to display");
            }
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
