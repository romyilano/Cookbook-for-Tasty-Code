//
//  Word.h
//  Vocabularies
//
//  Created by Romy Ilano on 1/15/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * translation;
// many to one relationship
@property (nonatomic, retain) NSManagedObject *vocabulary;

@end
