//
//  Employee.m
//  Sorting
//
//  Created by Romy Ilano on 1/16/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "Employee.h"

@implementation Employee
-(id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfHire:(NSDate *)dateOfHire age:(NSNumber *)age
{
    if ((self = [super init]))
    {
        self.firstName = firstName;
        self.lastName = lastName;
        self.dateOfHire = dateOfHire;
        self.age = age;
    }
    return self;
}
@end
