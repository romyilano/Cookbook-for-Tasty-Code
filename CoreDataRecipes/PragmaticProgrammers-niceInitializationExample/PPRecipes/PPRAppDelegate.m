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

@property (nonatomic, strong) NSURL *fileToOpenURL;

- (void)initializeCoreDataStack;
- (void)contextInitialized;

- (void)consumeIncomingFileURL:(NSURL*)url;

@end

@implementation PPRAppDelegate

@synthesize window;
@synthesize managedObjectContext;
@synthesize fileToOpenURL;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self initializeCoreDataStack];
  
  id controller = nil;
  
  UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
  if (idiom == UIUserInterfaceIdiomPad) {
    id splitViewController = [[self window] rootViewController];
    UINavigationController *navigationController = nil;
    navigationController = [[splitViewController viewControllers] lastObject];
    [splitViewController setDelegate:[navigationController topViewController]];
    
    UINavigationController *masterNC = nil;
    masterNC = [[splitViewController viewControllers] objectAtIndex:0];
    controller = [masterNC topViewController];
  } else {
    id navigationController = [[self window] rootViewController];
    controller = [navigationController topViewController];
  }
  
  [controller setManagedObjectContext:[self managedObjectContext]];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [self saveContext];
}

- (void)saveContext
{
  NSManagedObjectContext *moc = [self managedObjectContext];
  
  if (!moc) return;
  if (![moc hasChanges]) return;
  
  NSError *error = nil;
  ZAssert([moc save:&error], @"Error saving MOC: %@\n%@", [error localizedDescription], [error userInfo]);
}

- (void)contextInitialized;
{
  //Finish UI initialization
  if (![self fileToOpenURL]) return;
  [self consumeIncomingFileURL:[self fileToOpenURL]];
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation
{
  if ([self managedObjectContext]) {
    [self consumeIncomingFileURL:url];
  } else {
    [self setFileToOpenURL:url];
  }
  return YES;
}

#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PPRecipes" withExtension:@"momd"];
  ZAssert(modelURL, @"Failed to find model URL");
  
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  ZAssert(mom, @"Failed to initialize model");
  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  ZAssert(psc, @"Failed to initialize persistent store coordinator");
  
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [moc setPersistentStoreCoordinator:psc];
  
  [self setManagedObjectContext:moc];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    storeURL = [storeURL URLByAppendingPathComponent:@"PPRecipes.sqlite"];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator = [moc persistentStoreCoordinator];
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
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

#pragma mark - Import Handling

- (void)consumeIncomingFileURL:(NSURL*)url;
{
  NSData *data = [NSData dataWithContentsOfURL:url];
  PPRImportOperation *op = [[PPRImportOperation alloc] initWithData:data];
  [op setMainContext:[self managedObjectContext]];
  [op setCompletionBlock:^(BOOL success, NSError *error) {
    if (success) {
      //Clear visual feedback
    } else {
      //Present an error to the user
    }
  }];
  [[NSOperationQueue mainQueue] addOperation:op];
  
  //Give visual feedback of the import
}

@end
