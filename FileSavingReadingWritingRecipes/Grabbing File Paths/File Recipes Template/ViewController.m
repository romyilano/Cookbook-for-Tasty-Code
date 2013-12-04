//
//  ViewController.m
//  File Recipes Template
//
//  Created by Romy Ilano on 12/3/13.
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
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory
                                        inDomains:NSUserDomainMask];
    
    if ([urls count] > 0) {
        NSURL *documentsFolder = urls[0];
        NSLog(@"%@", documentsFolder);
    } else
    {
        NSLog(@"could not find the Documents folder");
    }
    
    // grab the caches folder
    NSArray *cachesURLs = [fileManager URLsForDirectory:NSCachesDirectory
                                              inDomains:NSUserDomainMask];
    if([cachesURLs count] > 0) {
        NSURL *cachesFolder = cachesURLs[0];
        NSLog(@"%@", cachesFolder);
    } else
    {
        NSLog(@"could not find the Documents folder");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
