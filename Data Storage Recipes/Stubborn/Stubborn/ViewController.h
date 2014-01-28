//
//  ViewController.h
//  Stubborn
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *activitySwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)toggleActivity:(id)sender;

@end
