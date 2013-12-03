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

@interface PPRAppDelegate()<UIAlertViewDelegate>

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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  exit(0);
}

#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
  NSError *error = nil;
  NSString *msg = nil;
  msg = [NSString stringWithFormat:@"The recipes database %@%@%@\n%@\n%@",
         @"is either corrupt or was created by a newer ",
         @"version of Grokking Recipes.  Please contact ",
         @"support to assist with this error.",
         [error localizedDescription], [error userInfo]];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"Quit"
                                            otherButtonTitles:nil];
  [alertView show];
  
  NSURL *modelURL = nil;
  modelURL = [[NSBundle mainBundle] URLForResource:@"PPRecipes"
                                     withExtension:@"momd"];
  ZAssert(modelURL, @"Failed to find model URL");
  
  NSManagedObjectModel *mom = nil;
  mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  ZAssert(mom, @"Failed to initialize model");
  
  NSFileManager *fm = [NSFileManager defaultManager];
  NSURL *storeURL = [[fm URLsForDirectory:NSDocumentDirectory
                                inDomains:NSUserDomainMask] lastObject];
  storeURL = [storeURL URLByAppendingPathComponent:@"PPRecipes.sqlite"];

  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  ZAssert(psc, @"Failed to initialize persistent store coordinator");
  
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [moc setPersistentStoreCoordinator:psc];
  
  [self setManagedObjectContext:moc];
  
  dispatch_queue_t queue = nil;
  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator = nil;
    coordinator = [moc persistentStoreCoordinator];
    NSPersistentStore *store = nil;
    store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                      configuration:nil
                                                URL:storeURL
                                            options:nil
                                              error:&error];
    if (!store) {
      ALog(@"Error adding persistent store to coordinator %@\n%@",
           [error localizedDescription], [error userInfo]);
      
      NSString *msg = nil;
      msg = [NSString stringWithFormat:@"The recipes database %@%@%@\n%@\n%@",
             @"is either corrupt or was created by a newer ",
             @"version of Grokking Recipes.  Please contact ",
             @"support to assist with this error.",
             [error localizedDescription], [error userInfo]];
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:msg
                                                         delegate:self
                                                cancelButtonTitle:@"Quit"
                                                otherButtonTitles:nil];
      [alertView show];
      return;
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
