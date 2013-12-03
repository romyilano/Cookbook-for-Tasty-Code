/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
#import "PPRRecipeMO.h"

@interface PPRDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) PPRRecipeMO *recipeMO;

@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *servesLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastServedLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;


- (IBAction)action:(id)sender;

@end
