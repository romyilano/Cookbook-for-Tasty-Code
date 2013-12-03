/***
 * Excerpted from "Core Data, 2nd Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/mzcd2 for more book information.
***/
typedef void (^CompletionBlock)(BOOL success, NSError *error);

@interface PPRImportOperation : NSOperation

@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, weak) NSManagedObjectContext *mainContext;

- (id)initWithData:(NSData*)data;

@end
