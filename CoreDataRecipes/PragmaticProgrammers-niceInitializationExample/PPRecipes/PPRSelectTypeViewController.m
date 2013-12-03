/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRSelectTypeViewController.h"

@interface PPRSelectTypeViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PPRSelectTypeViewController

@synthesize managedObjectContext;
@synthesize typeChangedBlock;
@synthesize fetchedResultsController;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Type"];
  
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[[self fetchedResultsController] fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  ZAssert(cell, @"Failed to resolve cell");
  
  NSManagedObject *type = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  [[cell textLabel] setText:[type valueForKey:@"name"]];
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *type = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  [self typeChangedBlock]([type valueForKey:@"name"]);
  
  [[self navigationController] popViewControllerAnimated:YES];
}



@end
