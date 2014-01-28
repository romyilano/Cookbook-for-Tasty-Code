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
    
    NSDateComponents *gComponents = [[NSDateComponents alloc] init];
    [gComponents setDay:[self.gDayTextField.text integerValue]];
    [gComponents setMonth:[self.gMonthTextField.text integerValue]];
    [gComponents setYear:[self.gYearTextField.text integerValue]];
    
    NSDate *gregorianDate = [self.gregorianCalendar dateFromComponents:gComponents];
    
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *hebrewDateComponents = [self.hebrewCalendar components:unitFlags fromDate:gregorianDate];
    
    self.hDayTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.day] stringValue];
    self.hMonthTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.month] stringValue];
    self.hYearTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.year] stringValue];
    
    
    
}

- (IBAction)convertToGregorian:(id)sender {
    
    
    // NSDateComponents used to define details that make up an NSDate such as the day
    //  the month, year, time and so on.
    NSDateComponents *hComponents = [[NSDateComponents alloc] init];
    [hComponents setDay:[self.hDayTextField.text integerValue]];
    [hComponents setMonth:[self.hMonthTextField.text integerValue]];
    [hComponents setYear:[self.hYearTextField.text integerValue]];
    
    
    NSDate *hebrewDate = [self.hebrewCalendar dateFromComponents:hComponents];
    
    // when you specify creating an instance of NSDateComponents out of NSDate, you need to
    //      specify exactly which components to include from the date.
    //      you can specify these flags called NSCalendarUnits through the use of NSUInteger
    //      as shown
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *hebrewDateComponents = [self.gregorianCalendar components:unitFlags fromDate:hebrewDate];
    
    self.gDayTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.day] stringValue];
    self.gMonthTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.month] stringValue];
    self.gYearTextField.text = [[NSNumber numberWithInteger:hebrewDateComponents.year] stringValue];
    
}
@end
