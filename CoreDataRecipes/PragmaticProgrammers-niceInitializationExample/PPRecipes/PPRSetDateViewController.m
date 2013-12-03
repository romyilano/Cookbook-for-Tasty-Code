/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRSetDateViewController.h"

@interface PPRSetDateViewController()

@end

@implementation PPRSetDateViewController

@synthesize datePicker;
@synthesize dateChangedBlock;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
  } else {
    return YES;
  }
}

- (IBAction)cancel:(id)sender;
{
  [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender;
{
  
  [self dateChangedBlock]([[self datePicker] date]);
  [[self navigationController] popViewControllerAnimated:YES];
}

@end
