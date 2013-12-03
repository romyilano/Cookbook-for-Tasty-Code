/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRAppDelegate.h"

#import "PPRMasterViewController.h"
#import "PPRImportOperation.h"

@interface PPRAppDelegate()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectCOntext *privateContext;

@property (nonatomic, strong) NSURL *fileToOpenURL;

- (void)initializeCoreDataStack;
- (void)contextInitialized;

- (void)consumeIncomingFileURL:(NSURL*)url;

@end

@implementation PPRAppDelegate

@synthesize window;
@synthesize managedObjectContext;
@synthesize fileToOpenURL;
@synthesize privateContext;

- (void)saveContext:(BOOL)wait
{
  NSManagedObjectContext *moc = [self managedObjectContext];
  NSManagedObjectContext *private = [self privateContext];
  
  if (!moc) return;
  if ([moc hasChanges]) {
    [moc performBlockAndWait:^{
      NSError *error = nil;
      ZAssert([moc save:&error], @"Error saving MOC: %@\n%@", 
              [error localizedDescription], [error userInfo]);
    }];
  }
  
  void (^savePrivate) (void) = ^{
    NSError *error = nil;
    ZAssert([private save:&error], @"Error saving private moc: %@\n%@", 
            [error localizedDescription], [error userInfo]);
  };

  if ([private hasChanges]) {
    if (wait) {
      [private performBlockAndWait:savePrivate];
    } else {
      [private performBlock:savePrivate];
    }
  }
}

#pragma mark - Core Data stack

// Romy - I like this - nice initialization method and he puts it all in one place
- (void)initializeCoreDataStack
{
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PPRecipes" withExtension:@"momd"];
  ZAssert(modelURL, @"Failed to find model URL");
  
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  ZAssert(mom, @"Failed to initialize model");
  
  NSPersistentStoreCoordinator *psc = nil;
  psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  ZAssert(psc, @"Failed to initialize persistent store coordinator");
  
  NSManagedObjectContext *private = nil;
  NSUInteger type = NSPrivateQueueConcurrencyType;
  private = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  [private setPersistentStoreCoordinator:psc];
  
  type = NSMainQueueConcurrencyType;
  NSManagedObjectContext *moc = nil;
  moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  [moc setParentContext:private];
  [self setPrivateContext:private];
  
  [self setManagedObjectContext:moc];
  
  // Romy - nice!!! thank you
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    storeURL = [storeURL URLByAppendingPathComponent:@"PPRecipes.sqlite"];
    
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (!store) {
      ALog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
      //Present a user facing error
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Type"];
    
    [moc performBlockAndWait:^{
      NSError *error = nil;
      NSInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
      ZAssert(count != NSNotFound || !error, @"Failed to count type: %@\n%@", [error localizedDescription], [error userInfo]);
      
      if (count) return;
      
      NSArray *types = [[[NSBundle mainBundle] infoDictionary] objectForKey:ppRecipeTypes];
      
      for (NSString *recipeType in types) {
        NSManagedObject *typeMO = [NSEntityDescription insertNewObjectForEntityForName:@"Type" inManagedObjectContext:moc];
        [typeMO setValue:recipeType forKey:@"name"];
      }
      
      ZAssert([moc save:&error], @"Error saving moc: %@\n%@", [error localizedDescription], [error userInfo]);
    }];
    
    [self contextInitialized];
  });
}

@end
