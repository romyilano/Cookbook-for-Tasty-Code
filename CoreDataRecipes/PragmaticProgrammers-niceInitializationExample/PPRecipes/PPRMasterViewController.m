/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
//
//  PPRMasterViewController.m
//  PPRecipes
//
//  Created by Marcus Zarra on 4/3/12.
//  Copyright (c) 2012 The Pragmatic Programmer. All rights reserved.
//

#import "PPRMasterViewController.h"

#import "PPRDetailViewController.h"
#import "PPREditRecipeViewController.h"

@interface PPRMasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PPRMasterViewController

@synthesize detailViewController;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (void)awakeFromNib
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    [self setClearsSelectionOnViewWillAppear:NO];
    [self setContentSizeForViewInPopover:CGSizeMake(320.0, 600.0)];
  }
  [super awakeFromNib];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
  
  id detailVC = [[[[self splitViewController] viewControllers] lastObject] topViewController];
  [self setDetailViewController:detailVC];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
  } else {
    return YES;
  }
}

#pragma mark - Segue handlers

- (void)prepareForDetailSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  id object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  [[segue destinationViewController] setRecipeMO:object];
}

- (void)prepareForAddRecipeSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  NSManagedObjectContext *context = nil;
  NSEntityDescription *entity = nil;
  PPRRecipeMO *newMO = nil;
  
  context = [[self fetchedResultsController] managedObjectContext];
  entity = [[[self fetchedResultsController] fetchRequest] entity];
  newMO = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                            inManagedObjectContext:context];
  [[segue destinationViewController] setRecipeMO:newMO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showRecipe"]) {
    [self prepareForDetailSegue:segue sender:sender];
    return;
  } else if ([[segue identifier] isEqualToString:@"addRecipe"]) {
    [self prepareForAddRecipeSegue:segue sender:sender];
    return;
  }
  ALog(@"Unknown segue: %@", [segue identifier]);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle != UITableViewCellEditingStyleDelete) return;
  
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) return;
  
  id object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  [[self detailViewController] setRecipeMO:object];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
  if (fetchedResultsController) return fetchedResultsController;
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
  [fetchRequest setFetchBatchSize:20];
  
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
  
  [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"Master"]];
  [[self fetchedResultsController] setDelegate:self];
  
	NSError *error = nil;
	ZAssert([[self fetchedResultsController] performFetch:&error], @"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
  
  return fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
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

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [[self tableView] endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[object valueForKey:@"name"]];
}

@end
