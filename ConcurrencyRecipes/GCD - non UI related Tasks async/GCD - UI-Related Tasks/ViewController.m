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

#pragma mark - first sample
-(void)logoDownload
{
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

#pragma mark - Second Sample - Random Number Array
/*
 
 Take an array of 10,000 random number that have been stored in file on disk
 and load this array into memory, sort the numbers in an ascending fashion
 (with the smallest number appearing first in the list) and then display the
 list to the user
 
 */
-(NSString *)fileLocation
{
    // get document folders
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // did we find anything?
    if ([folders count] == 0)
    {
        return nil;
    }
    
    // get 1st folder
    NSString *documentsFolder = folders[0];
    
    // append filename to the end of the documents path
    return [documentsFolder stringByAppendingString:@"list.txt"];
    
}

-(BOOL)hasFileAlreadyBeenCreated
{
    BOOL result = NO;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[self fileLocation]])
    {
        result = YES;
    }
    return result;
}

-(void)randomNumberSample
{
    
    // save array of 10,000 random #'s IFF we have not created this array before on the disk
    // if we have we will load the array from disk immediately
    // if we have not we will first create it then move on to loading it from the desk
    // if the array was successfully read from the disk, we will sort the array in an
    // ascending fashion and finally display the results to the user on the UI
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*
     If we haven't already saved an array of 10,000 random #'s to the disk before, generate
     these numbers now and then save them to the disk in an array
     */
    
    dispatch_async(concurrentQueue, ^{
        
        NSUInteger numberOfValuesRequired = 10000;
        
        if([self hasFileAlreadyBeenCreated] == NO)
        {
            dispatch_sync(concurrentQueue, ^{
                
                NSMutableArray *arrayOfRandomNumbers = [[NSMutableArray alloc] initWithCapacity:numberOfValuesRequired];
                
                NSUInteger counter = 0;
                
                for (counter = 0; counter < numberOfValuesRequired; counter++ )
                {
                    unsigned int randomNumber = arc4random() % ((unsigned int) RAND_MAX + 1);
                    
                    [arrayOfRandomNumbers addObject:[NSNumber numberWithUnsignedInt:randomNumber]];
                }
                
                // now let's write the array to disk
                [arrayOfRandomNumbers writeToFile:[self fileLocation]
                                       atomically:YES];
            });
        }
        
        __block NSMutableArray *randomNumbers = nil;
        
        // read #'s from disk and sort them in an ascending fashion
        dispatch_sync(concurrentQueue, ^{
            
            // if the file has now been created
            // we have to read it
            if([self hasFileAlreadyBeenCreated]) {
                randomNumbers = [[NSMutableArray alloc] initWithContentsOfFile:[self fileLocation]];
                
                // now sort the numbers
                [randomNumbers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSNumber *number1 = (NSNumber *)obj1;
                    NSNumber *number2 = (NSNumber *)obj2;
                    return [number1 compare:number2];
                }];
            }
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([randomNumbers count] > 0 ) {
                // return the ui here using numbers in the random number array
            }
        });
    });
    
}


@end
