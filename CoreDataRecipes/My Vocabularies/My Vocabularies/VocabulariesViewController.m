//
//  VocabulariesViewController.m
//  My Vocabularies
//
//  Created by Romy Ilano on 12/8/13.
//  Copyright (c) 2013 Romy Ilano. All rights reserved.
//

#import "VocabulariesViewController.h"



@interface VocabulariesViewController ()

@end

@implementation VocabulariesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
    
-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{

    self = [super init];
    if (self)
    {
        self.moc = context;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Vocabularies";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    [self fetchVocabularies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
    
// Nice quick and dirty way to get the goods
-(void)fetchVocabularies
{
 
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Vocabulary"];
    NSString *cacheName = [@"Vocabulary" stringByAppendingString:@"Cache"];
    
    // sorts alphabetically by name
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                     ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                   managedObjectContext:self.moc
                                                     sectionNameKeyPath:nil
                                                              cacheName:cacheName];
    
    NSError *error = nil;
    if(![self.frc performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
    
    if ([[[self frc] fetchedObjects] count] == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Blank Slate"
                                    message:@"Hey! You haven't added any vocabulary words yet"
                                   delegate:self
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

-(void)add
{

    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:@"New Vocabulary"
                                                         message:@"Enter a name for a new vocabulary"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [inputAlert show];
    
}
    
#pragma mark - UIAlertViewDelegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSEntityDescription *vocabularyEntityDescription = [NSEntityDescription entityForName:@"Vocabulary"
                                                                       inManagedObjectContext:self.moc];
        
        Vocabulary *newVocabulary = (Vocabulary *)[[NSManagedObject alloc] initWithEntity:vocabularyEntityDescription
                                                           insertIntoManagedObjectContext:self.moc];
        newVocabulary.name = [alertView textFieldAtIndex:0].text;
        
        NSError *error = nil;
        
        if (![self.moc save:&error])
        {
            NSLog(@"error saving context: %@", error);
        }
        
        [self fetchVocabularies];
        [self.tableView reloadData];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.frc.fetchedObjects.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Vocabulary *vocabulary = (Vocabulary *)[self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = vocabulary.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)", vocabulary.words.count];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}self	VocabulariesViewController *	0x8a79170	0x08a79170
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
