//
//  VocabulariesViewController.h
//  Vocabularies
//
//  Created by Romy Ilano on 1/15/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vocabulary.h"

@interface VocabulariesViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
