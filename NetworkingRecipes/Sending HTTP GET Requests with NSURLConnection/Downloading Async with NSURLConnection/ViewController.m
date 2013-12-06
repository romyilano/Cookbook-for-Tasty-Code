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
    
    
    NSString *urlAsString = @"http://pixolity.com/get.php";
    urlAsString = [urlAsString stringByAppendingString:@"?param1=First"];
    urlAsString = [urlAsString stringByAppendingString:@"&param2=Second"];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                              
                               if ([data length] > 0 && connectionError == nil) {
                                   NSString *html = [[NSString alloc] initWithData:data
                                                                          encoding:NSUTF8StringEncoding];
                                   NSLog(@"HTML = %@", html);
                                   // now put it in the main thread, in the text view
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                       self.textView.text = html;
                                   }];
                                   
                               }
                               else if ([data length] == 0 && connectionError == nil)
                               {
                                   NSLog(@"Nothing was downloaded.");
                               }
                               else if (connectionError != nil)
                               {
                                   NSLog(@"Error happened = %@", connectionError);
                               }
                           }];
    

    
}
@end
