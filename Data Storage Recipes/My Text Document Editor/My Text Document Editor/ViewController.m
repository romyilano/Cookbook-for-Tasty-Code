//
//  ViewController.m
//  My Text Document Editor
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(NSString *)currentContentFilePath;
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

# pragma mark - Custom Methods
// helper method that transforms the relative filename into an absolute file path within the
//  Documents directory of the Device
-(NSString *)currentContentFilePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:self.filenameTextField.text];
}

#pragma mark - Action methods
- (IBAction)saveContent:(id)sender {
    
    NSString *filePath = [self currentContentFilePath];
    NSString *content = self.contentTextView.text;
    
    NSError *error = nil;
    
    BOOL success = [content writeToFile:filePath
                             atomically:YES
                               encoding:NSUnicodeStringEncoding
                                  error:&error];
    
    if (!success)
    {
        NSLog(@"Unable to save file: %@\nError: %@", filePath, error);
    }
}

- (IBAction)loadContent:(id)sender {
    
    NSString *filePath = [self currentContentFilePath];
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUnicodeStringEncoding
                                                     error:&error];
    
    if (error)
    {
        NSLog(@"Unable to laod file: %@\Error: %@", filePath, error);
    }
    
    self.contentTextView.text = content;
}

- (IBAction)clearContent:(id)sender {
    
    self.contentTextView.text = nil;
    
}
@end
