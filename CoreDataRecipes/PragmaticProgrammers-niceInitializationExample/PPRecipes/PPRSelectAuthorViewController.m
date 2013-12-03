/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRSelectAuthorViewController.h"

#import "PPRTextEditViewController.h"

@interface PPRSelectAuthorViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PPRSelectAuthorViewController

@synthesize selectAuthorBlock;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
  } else {
    return YES;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
  
  NSMutableArray *sortArray = [NSMutableArray array];
  [sortArray addObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
  [fetchRequest setSortDescriptors:sortArray];
  
  id frc = nil;
  frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
  [frc setDelegate:self];
  
  NSError *error = nil;
  [frc performFetch:&error];
  [self setFetchedResultsController:frc];
}

- (IBAction)cancel:(id)sender;
{
  [[self navigationController] popViewControllerAnimated:YES];
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
  id controller = [segue destinationViewController];
  
  [controller setTextChangedBlock:^ BOOL (NSString *text, NSError **error) {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", text]];
    
    NSError *internalError = nil;
    NSInteger count = [[self managedObjectContext] countForFetchRequest:request error:&internalError];
    if (count == NSNotFound) {
      *error = internalError;
      return NO;
    }
    
    if (count > 0) {
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setValue:@"Author already exists" forKey:NSLocalizedDescriptionKey];
      *error = [NSError errorWithDomain:ppErrorDomain code:1123 userInfo:dict];
      return NO;
    }
    
    NSManagedObject *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:[self managedObjectContext]];
    [newAuthor setValue:text forKey:@"name"];
    
    return YES;
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger count = [[[self fetchedResultsController] fetchedObjects] count];
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
  
  cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  ZAssert(cell, @"Failed to resolve cell");
  
  NSManagedObject *author = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  [[cell textLabel] setText:[author valueForKey:@"name"]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObject *authorToDelete = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:authorToDelete];
    return;
  }
  
  [self performSegueWithIdentifier:@"addAuthor" sender:self];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath row] >= [[[self fetchedResultsController] fetchedObjects] count]) { //Insert Row
    return YES;
  }
  
  NSManagedObject *author = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  //Only delete authors that are not associated with recipes
  return ([[author valueForKey:@"recipes"] count] == 0);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath row] >= [[[self fetchedResultsController] fetchedObjects] count]) { //Insert Row
    return UITableViewCellEditingStyleInsert;
  }
  
  NSManagedObject *author = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  //Only delete authors that are not associated with recipes
  if ([[author valueForKey:@"recipes"] count]) {
    return UITableViewCellEditingStyleNone;
  } else {
    return UITableViewCellEditingStyleDelete;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger count = [[[self fetchedResultsController] fetchedObjects] count];
  if ([indexPath row] >= count) {
    //    [self insertNewAuthor];
    return;
  }
  
  NSManagedObject *authorMO = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  [self selectAuthorBlock](authorMO);
  
  [[self navigationController] popViewControllerAnimated:YES];
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
