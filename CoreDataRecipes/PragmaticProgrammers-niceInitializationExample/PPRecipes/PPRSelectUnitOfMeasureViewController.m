/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRSelectUnitOfMeasureViewController.h"

#import "PPRTextEditViewController.h"

@interface PPRSelectUnitOfMeasureViewController () <NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation PPRSelectUnitOfMeasureViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UnitOfMeasure"];
  
  NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:nameSort]];
  
  NSFetchedResultsController *frc = nil;
  frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
  [frc setDelegate:self];
  
  NSError *error = nil;
  ZAssert([frc performFetch:&error], @"Error fetchign UofM: %@\n%@", [error localizedDescription], [error userInfo]);
  
  [self setFetchedResultsController:frc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  ZAssert([[segue identifier] isEqualToString:@"addUnitOfMeasure"], @"Unknown segue");
  
  id controller = [segue destinationViewController];
  controller = [[controller viewControllers] lastObject];
  
  [controller setTextChangedBlock:^ BOOL (NSString *text, NSError **error) {
    if (!text || ![text length]) return YES;
    
    NSManagedObject *newUofM = [NSEntityDescription insertNewObjectForEntityForName:@"UnitOfMeasure" inManagedObjectContext:[self managedObjectContext]];
    [newUofM setValue:text forKey:@"name"];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    return YES;
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  
  NSManagedObject *unitOfMeasure = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[unitOfMeasure valueForKey:@"name"]];
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *unitOfMeasure = [self.fetchedResultsController objectAtIndexPath:indexPath];
  self.selectUnitOfMeasure(unitOfMeasure);
  
  [self.navigationController popViewControllerAnimated:YES];
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
