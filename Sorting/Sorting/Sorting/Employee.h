//
//  Employee.h
//  Sorting
//
//  Created by Romy Ilano on 1/16/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *dateOfHire;
@property (strong, nonatomic) NSNumber *age;
@end
