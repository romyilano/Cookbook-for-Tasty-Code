/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRAddRecipeIngredientViewController.h"

#import "PPRTextEditViewController.h"
#import "PPRSelectIngredientTypeViewController.h"

@interface PPRAddRecipeIngredientViewController() <NSFetchedResultsControllerDelegate>

@end

@implementation PPRAddRecipeIngredientViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSManagedObject *ingredientType = [[self recipeIngredientMO] valueForKey:@"ingredient"];
  if (!ingredientType) return;
    
  NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
  UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
  [[cell detailTextLabel] setText:[ingredientType valueForKey:@"name"]];
  
  path = [NSIndexPath indexPathForRow:0 inSection:0];
  cell = [[self tableView] cellForRowAtIndexPath:path];
  [[cell textLabel] setText:[ingredientType valueForKeyPath:@"unitOfMeasure.name"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSString *identifier = [segue identifier];
  id viewController = [segue destinationViewController];
  
  if ([identifier isEqualToString:@"setQuantity"]) {
    [[viewController textField] setText:[[[self recipeIngredientMO] valueForKey:@"quantity"] stringValue]];
    
    [viewController setTextChangedBlock:^ BOOL (NSString *text, NSError **error) {
      NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
      
      NSNumber *quantity = [numberFormatter numberFromString:text];
      if (!quantity) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Invalid quantity" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"PragProg" code:1123 userInfo:dict];
        return NO;
      }
      
      NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
      UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell detailTextLabel] setText:text];
      [[self recipeIngredientMO] setValue:quantity forKey:@"quantity"];
      
      return YES;
    }];
  } else if ([identifier isEqualToString:@"selectType"]) {
    [viewController setManagedObjectContext:[[self recipeIngredientMO] managedObjectContext]];
    [viewController setSelectIngredientType:^(NSManagedObject *ingredientType) {
      [[self recipeIngredientMO] setValue:ingredientType forKey:@"ingredient"];
      
      NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
      UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell detailTextLabel] setText:[ingredientType valueForKey:@"name"]];
      
      path = [NSIndexPath indexPathForRow:0 inSection:0];
      cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell textLabel] setText:[ingredientType valueForKeyPath:@"unitOfMeasure.name"]];
    }];
  }
}

- (IBAction)save:(id)sender;
{
  [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender;
{
  NSManagedObjectContext *moc = [[self recipeIngredientMO] managedObjectContext];
  [moc deleteObject:[self recipeIngredientMO]];
  [[self navigationController] popViewControllerAnimated:YES];
}

@end
