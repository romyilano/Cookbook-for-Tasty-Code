//
//  ViewController.h
//  GCD - UI-Related Tasks
//
//  Created by Romy Ilano on 12/1/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


// sample block object
@property (nonatomic, copy) void (^simpleCountingBlock)(void);

@end
