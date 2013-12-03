/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRCreateIngredientTypeViewController.h"

#import "PPRTextEditViewController.h"
#import "PPRSelectUnitOfMeasureViewController.h"

@interface PPRCreateIngredientTypeViewController()

@end

@implementation PPRCreateIngredientTypeViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSString *identifier = [segue identifier];
  id controller = [segue destinationViewController];
  
  if ([identifier isEqualToString:@"setName"]) {
    [[controller textField] setText:[[self ingredientTypeMO] valueForKey:@"name"]];
    
    [controller setTextChangedBlock:^ BOOL (NSString *text, NSError **error) {
      NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
      UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell detailTextLabel] setText:text];
      [[self ingredientTypeMO] setValue:text forKey:@"name"];
      
      return YES;
    }];
  } else if ([identifier isEqualToString:@"setValue"]) {
    [[controller textField] setText:[[[self ingredientTypeMO] valueForKey:@"cost"] stringValue]];
    
    BOOL (^changedText)(NSString *text, NSError **error) = ^(NSString *text, NSError **error) {
      NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
      
      NSNumber *value = [numberFormatter numberFromString:text];
      if (!value) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Invalid value" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"PragProg" code:1123 userInfo:dict];
        return NO;
      }
      
      NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
      UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell detailTextLabel] setText:text];
      [[self ingredientTypeMO] setValue:value forKey:@"cost"];
      
      return YES;
    };
    
    [controller setTextChangedBlock:changedText];
  } else if ([identifier isEqualToString:@"selectUnitOfMeasure"]) {
    [controller setManagedObjectContext:[[self ingredientTypeMO] managedObjectContext]];
    [controller setSelectUnitOfMeasure:^(NSManagedObject *unit) {
      [[self ingredientTypeMO] setValue:unit forKey:@"unitOfMeasure"];
      
      NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
      UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
      [[cell detailTextLabel] setText:[unit valueForKey:@"name"]];
    }];
  }
}

- (IBAction)cancel:(id)sender;
{
  NSManagedObjectContext *moc = [[self ingredientTypeMO] managedObjectContext];
  [moc deleteObject:[self ingredientTypeMO]];
  [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender;
{
  [[self navigationController] popViewControllerAnimated:YES];
}

@end
