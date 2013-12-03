/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRImportOperation.h"

@interface PPRImportOperation()

@property (nonatomic, strong) NSData *incomingData;

- (void)populateManagedObject:(NSManagedObject*)mo 
               fromDictionary:(NSDictionary*)dict;

@end

@implementation PPRImportOperation

@synthesize completionBlock;
@synthesize incomingData;
@synthesize mainContext;

- (id)initWithData:(NSData*)data
{
  if (!(self = [super init])) return nil;
  
  [self setIncomingData:data];
  
  return self;
}

- (void)contextDidSave:(NSNotification*)notification
{
  NSManagedObjectContext *moc = [self mainContext];
  void (^mergeChanges) (void) = ^ {
    [moc mergeChangesFromContextDidSaveNotification:notification];
  };
  
  if ([NSThread isMainThread]) {
    mergeChanges();
  } else {
    dispatch_sync(dispatch_get_main_queue(), mergeChanges);
  }
}

- (void)main
{
  NSManagedObjectContext *localMOC = nil;
  NSUInteger type = NSConfinementConcurrencyType;
  localMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  [localMOC setParentContext:[self mainContext]];
  
  NSError *error = nil;
  id recipesJSON = nil;
  recipesJSON = [NSJSONSerialization JSONObjectWithData:[self incomingData] 
                                                options:0 
                                                  error:&error];
  if (!recipesJSON && error) {
    [self completionBlock](NO, error);
    return;
  }
  
  NSManagedObject *recipeMO = nil;
  
  if ([recipesJSON isKindOfClass:[NSDictionary class]]) {
    recipeMO = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
                                             inManagedObjectContext:localMOC];
    
    [self populateManagedObject:recipeMO fromDictionary:recipesJSON];
    return;
  } else {
    ZAssert([recipesJSON isKindOfClass:[NSArray class]], 
            @"Unknown structure root: %@", [recipesJSON class]);
    for (id recipeDict in recipesJSON) {
      ZAssert([recipeDict isKindOfClass:[NSDictionary class]], 
              @"Unknown recipe structure: %@", [recipeDict class]);
      recipeMO = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
                                               inManagedObjectContext:localMOC];
      
      [self populateManagedObject:recipeMO fromDictionary:recipeDict];
    }
    
    ZAssert([localMOC save:&error], @"Error saving import context: %@\n%@", 
            [error localizedDescription], [error userInfo]);
  }
}

- (void)populateManagedObject:(NSManagedObject*)mo 
               fromDictionary:(NSDictionary*)dict
{
  NSManagedObjectContext *context = [mo managedObjectContext];
  NSEntityDescription *entity = [mo entity];
  NSArray *attKeys = [[entity attributesByName] allKeys];
  NSDictionary *atttributesDict = [dict dictionaryWithValuesForKeys:attKeys];
  [mo setValuesForKeysWithDictionary:atttributesDict];
  
  NSManagedObject* (^createChild)(NSDictionary *childDict, 
                                  NSEntityDescription *destEntity, 
                                  NSManagedObjectContext *context);
  
  createChild = ^(NSDictionary *childDict, NSEntityDescription *destEntity, 
                  NSManagedObjectContext *context) {
    NSManagedObject *destMO = nil;
    destMO = [[NSManagedObject alloc] initWithEntity:destEntity
                      insertIntoManagedObjectContext:context];
    [self populateManagedObject:destMO fromDictionary:childDict];
    return destMO;
  };

  
  NSDictionary *relationshipsByName = [entity relationshipsByName];
  NSManagedObject *destMO = nil;
  
  for (NSString *key in relationshipsByName) {
    id childStructure = [dict valueForKey:key];
    if (!childStructure) continue; //Relationship not populated
    NSRelationshipDescription *relDesc = [relationshipsByName valueForKey:key];
    NSEntityDescription *destEntity = [relDesc destinationEntity];
    
    if (![relDesc isToMany]) { //ToOne
      destMO = createChild(childStructure, destEntity, context);
      [mo setValue:destMO forKey:key];
      continue;
    }
    
    NSMutableSet *childSet = [NSMutableSet set];
    for (NSDictionary *childDict in childStructure) {
      destMO = createChild(childDict, destEntity, context);
      [childSet addObject:destMO];
    }
    [self setValue:childSet forKey:key];
  }
}

@end
