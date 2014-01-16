//
//  ViewController.h
//  Sorting
//
//  Created by Romy Ilano on 1/16/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)orderByAgeBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *orderByHireDateBtnPressed;
- (IBAction)orderByHireDateBtnPressed:(id)sender;
- (IBAction)recreateButtonPressed:(id)sender;

@end
