/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRDetailViewController.h"

#import "PPRExportOperation.h"
#import "PPREditRecipeViewController.h"

@interface PPRDetailViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
- (void)mailRecipe;

@end

@implementation PPRDetailViewController

@synthesize recipeMO;
@synthesize masterPopoverController;

@synthesize recipeNameLabel;
@synthesize authorLabel;
@synthesize typeLabel;
@synthesize servesLabel;
@synthesize lastServedLabel;
@synthesize descriptionLabel;

#pragma mark - Managing the detail item

- (void)configureView
{
  if (![self recipeMO]) return;
  
  PPRRecipeMO *mo = [self recipeMO];
  UILabel *label = [self recipeNameLabel];
  [label setText:[mo valueForKey:@"name"]];
  
  label = [self authorLabel];
  [label setText:[mo valueForKeyPath:@"author.name"]];
  
  label = [self typeLabel];
  [label setText:[mo valueForKey:@"type"]];
  
  label = [self servesLabel];
  NSNumber *value = [mo valueForKey:@"serves"];
  [label setText:[NSString stringWithFormat:@"Serves: %@", value]];
  
  label = [self lastServedLabel];
  [label setText:[mo lastUsedString]];
  
  label = [self descriptionLabel];
  [label setText:[mo valueForKey:@"desc"]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureView];
}

- (void)prepareForEditSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  id controller = [segue destinationViewController];
  [controller setRecipeMO:[self recipeMO]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"editRecipe"]) {
    [self prepareForEditSegue:segue sender:sender];
    return;
  }
  ALog(@"Unknown segue: %@", [segue identifier]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIDeviceOrientationIsPortrait(orient);
  } else {
    return YES;
  }
}

- (IBAction)action:(id)sender;
{
  UIActionSheet *sheet = [[UIActionSheet alloc] init];
  [sheet addButtonWithTitle:@"Mail Recipe"];
  [sheet addButtonWithTitle:@"Cancel"];
  [sheet setCancelButtonIndex:([sheet numberOfButtons] - 1)];
  [sheet setDelegate:self];
  [sheet showInView:[self view]];
}

- (void)mailRecipe
{
  PPRExportOperation *operation = nil;
  operation = [[PPRExportOperation alloc] initWithRecipe:[self recipeMO]];
  [operation setCompletionBlock:^(NSData *data, NSError *error) {
    ZAssert(data || !error, @"Error: %@\n%@", [error localizedDescription], 
            [error userInfo]);
    //Mail the data to a friend
  }];
  
  [[NSOperationQueue mainQueue] addOperation:operation];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == [actionSheet cancelButtonIndex]) return;
  switch (buttonIndex) {
    case 0: //Mail Recipe
      [self mailRecipe];
      break;
    default:
      ALog(@"Unknown index: %i", buttonIndex);
  }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController 
     willHideViewController:(UIViewController *)viewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)popoverController
{
  [barButtonItem setTitle:NSLocalizedString(@"Master", @"Master")];
  [[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
  [self setMasterPopoverController:popoverController];
}

- (void)splitViewController:(UISplitViewController *)splitController 
     willShowViewController:(UIViewController *)viewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
  [self setMasterPopoverController:nil];
}

@end
