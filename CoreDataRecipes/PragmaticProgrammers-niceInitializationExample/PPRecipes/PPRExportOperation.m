/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRExportOperation.h"

@interface PPRExportOperation()

@property (nonatomic, weak) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectID *incomingRecipeID;

@end

@implementation PPRExportOperation

@synthesize completionBlock;
@synthesize incomingRecipeID;
@synthesize persistentStoreCoordinator;

- (id)initWithRecipe:(PPRRecipeMO*)recipe;
{
  if (!(self = [super init])) return nil;
  
  [self setIncomingRecipeID:[recipe objectID]];
  NSManagedObjectContext *moc = [recipe managedObjectContext];
  [self setPersistentStoreCoordinator:[moc persistentStoreCoordinator]];
  return self;
}

- (NSDictionary*)moToDictionary:(NSManagedObject*)mo
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  if (!mo) return dict;
  NSEntityDescription *entity = [mo entity];
  
  NSArray *attributeKeys = [[entity attributesByName] allKeys];
  NSDictionary *values = [mo dictionaryWithValuesForKeys:attributeKeys];
  [dict addEntriesFromDictionary:values];
  
  NSDictionary *relationships = [entity relationshipsByName];
  NSRelationshipDescription *relDesc = nil;
  for (NSString *key in relationships) {
    relDesc = [relationships objectForKey:key];
    if (![[[relDesc userInfo] valueForKey:ppExportRelationship] boolValue]) {
      DLog(@"Skipping %@", [relDesc name]);
      continue;
    }
    
    if ([relDesc isToMany]) {
      NSMutableArray *array = [NSMutableArray array];
      for (NSManagedObject *childMO in [mo valueForKey:key]) {
        [array addObject:[self moToDictionary:childMO]];
      }
      [dict setValue:array forKey:key];
      continue;
    }
    NSManagedObject *childMO = [mo valueForKey:key];
    [dict addEntriesFromDictionary:[self moToDictionary:childMO]];
  }
  return dict;
}

- (void)main
{
  ZAssert([self completionBlock], @"No completion block set");
  NSManagedObjectContext *localMOC = nil;
  localMOC = [[NSManagedObjectContext alloc] init];
  
  NSPersistentStoreCoordinator *psc = nil;
  psc = [self persistentStoreCoordinator];
  [localMOC setPersistentStoreCoordinator:psc];
  
  NSManagedObject *localRecipe = nil;
  localRecipe = [localMOC objectWithID:[self incomingRecipeID]];
  ZAssert(localRecipe, @"Failed to find recipe");
  
  NSError *error = nil;
  NSDictionary *objectStructure = [self moToDictionary:localRecipe];
  NSData *data = [NSJSONSerialization dataWithJSONObject:objectStructure
                                                 options:0 
                                                   error:&error];
  
  [self completionBlock](data, error);
}

@end
