//
//  Vocabulary.h
//  Vocabularies
//
//  Created by Romy Ilano on 1/15/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Vocabulary : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *words;
@end

@interface Vocabulary (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;

// one to many relationship
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
