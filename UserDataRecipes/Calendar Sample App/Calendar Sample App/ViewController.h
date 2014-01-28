//
//  ViewController.h
//  Calendar Sample App
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *gMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *gDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *gYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *hMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *hDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *hYearTextField;

- (IBAction)convertToHebrew:(id)sender;
- (IBAction)convertToGregorian:(id)sender;
@end
