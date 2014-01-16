//
//  Person.h
//  Basic Core Data
//
//  Created by Romy Ilano on 1/15/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;

@end
