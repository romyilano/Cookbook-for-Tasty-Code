//
//  ViewController.h
//  Downloading Async with NSURLConnection
//
//  Created by Romy Ilano on 12/5/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)btnPressed:(UIButton *)sender;


@end
