/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
@interface PPRSelectTypeViewController : UITableViewController

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) void (^typeChangedBlock)(NSString *newText);

- (IBAction)cancel:(id)sender;

@end
