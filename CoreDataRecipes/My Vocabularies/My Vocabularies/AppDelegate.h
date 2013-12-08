//
//  AppDelegate.h
//  My Vocabularies
//
//  Created by Romy Ilano on 12/8/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VocabulariesViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

    
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) VocabulariesViewController *vocabulariesViewController;
    
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
