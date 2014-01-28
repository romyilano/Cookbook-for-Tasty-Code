//
//  ViewController.m
//  Calendar Sample App
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

# pragma mark - Setters & Getters (accessor methods)

// lazy initialization
-(NSCalendar *)gregorianCalendar
{
    if (!_gregorianCalendar)
    {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _gregorianCalendar;
}

// lazy initialization
-(NSCalendar *)hebrewCalendar
{
    if (!_hebrewCalendar)
    {
        _hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    }
    return _hebrewCalendar;
}

#pragma mark - Action methods

- (IBAction)convertToHebrew:(id)sender {
}

- (IBAction)convertToGregorian:(id)sender {
}
@end
