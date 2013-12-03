/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRSelectIngredientTypeViewController.h"

#import "PPRCreateIngredientTypeViewController.h"

@interface PPRSelectIngredientTypeViewController () <NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation PPRSelectIngredientTypeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
  
  NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:nameSort]];
  
  NSFetchedResultsController *frc = nil;
  frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
  
  [frc setDelegate:self];
  
  NSError *error = nil;
  ZAssert([frc performFetch:&error], @"Error fetching ingredients: %@\n%@", [error localizedDescription], [error userInfo]);
  
  [self setFetchedResultsController:frc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  
  NSInteger count = [[[self fetchedResultsController] fetchedObjects] count];
  NSIndexPath *insertRowPath = [NSIndexPath indexPathForRow:count inSection:0];
  
  if (!editing) {
    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:insertRowPath] withRowAnimation:UITableViewRowAnimationFade];
  } else {
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:insertRowPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSString *identifier = [segue identifier];
  id controller = [segue destinationViewController];
  
  if ([identifier isEqualToString:@"createIngredientType"]) {
    NSManagedObject *ingredientType = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:[self managedObjectContext]];
    
    [controller setIngredientTypeMO:ingredientType];
  }
  
  [self setEditing:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger count = [[[[self fetchedResultsController] sections] objectAtIndex:section] numberOfObjects];
  if ([self isEditing]) return (count + 1);
  return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  if ([indexPath row] >= [[[self fetchedResultsController] fetchedObjects] count]) { //Insert Row
    cell = [tableView dequeueReusableCellWithIdentifier:kInsertCellIdentifier];
    ZAssert(cell, @"Failed to resolve cell");
    return cell;
  }

  cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  
  NSManagedObject *ingredientType = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[ingredientType valueForKey:@"name"]];
  
  NSNumber *value = [ingredientType valueForKey:@"cost"];
  NSNumberFormatter *currency = [[NSNumberFormatter alloc] init];
  [currency setNumberStyle:NSNumberFormatterCurrencyStyle];
  
  NSString *valueString = [currency stringFromNumber:value];
  NSString *uOfM = [ingredientType valueForKeyPath:@"unitOfMeasure.name"];
  NSString *detail = [NSString stringWithFormat:@"%@ per %@", valueString, uOfM];
  [[cell detailTextLabel] setText:detail];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObject *objectToDelete = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:objectToDelete];
    return;
  }
  
  [self performSegueWithIdentifier:@"createIngredientType" sender:self];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *ingredientType = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  self.selectIngredientType(ingredientType);
  
  [[self navigationController] popViewControllerAnimated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath row] >= [[[self fetchedResultsController] fetchedObjects] count]) { //Insert Row
    return UITableViewCellEditingStyleInsert;
  }
  return UITableViewCellEditingStyleDelete;
}

#pragma mark - NSFetchedResultsControllerDelegate -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeMove:
      [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [[self tableView] endUpdates];
}

@end
