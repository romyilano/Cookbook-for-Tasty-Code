//
//  VocabulariesViewController.h
//  My Vocabularies
//
//  Created by Romy Ilano on 12/8/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vocabulary.h"

@interface VocabulariesViewController : UITableViewController <UIAlertViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSFetchedResultsController *frc;
    
-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
-(void)fetchVocaulabries;
@end
