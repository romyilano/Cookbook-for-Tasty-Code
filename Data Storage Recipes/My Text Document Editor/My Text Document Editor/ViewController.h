//
//  ViewController.h
//  My Text Document Editor
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *filenameTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)saveContent:(id)sender;
- (IBAction)loadContent:(id)sender;
- (IBAction)clearContent:(id)sender;
@end
