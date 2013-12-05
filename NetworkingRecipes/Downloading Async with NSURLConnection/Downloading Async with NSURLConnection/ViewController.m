//
//  ViewController.m
//  Downloading Async with NSURLConnection
//
//  Created by Romy Ilano on 12/5/13.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(UIButton *)sender {
    
    NSString *urlAsString = @"http://www.sudoroom.org";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil) {
                                   // get documents directory
                                   NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                   
                                   // append file name to the documents directory
                                   NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"wiki/Main_Page"];
                                   
                                   // write the data to the file
                                   [data writeToFile:filePath atomically:YES];
                                   
                                   NSLog(@"successfully saved the file to %@", filePath);
                                   
                                   
                                   // this has to be done on the main thread
                                   // put it in the textview
                                   
                                   // grab the main thread sinc ethis is ui
                                   NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
                                   
                                   [mainQueue addOperationWithBlock:^{
                                       NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       
                                       self.textView.text = dataString;
                                   }];
                                  
                                   
                               } else if ([data length] == 0 && connectionError == nil)
                               {
                                   NSLog(@"Nothing was downloaded");
                               }
                               else if (connectionError != nil) {
                                   NSLog(@"error happened = %@", connectionError);
                               }
                           }];
    
}
@end
