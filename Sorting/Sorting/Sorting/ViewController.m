//
//  ViewController.m
//  Sorting
//
//  Created by Romy Ilano on 1/16/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *employees;
@property (strong ,nonatomic) NSArray *arrayOfNumbers;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (self.employees.count == 0)
    {
        [self loadEmployees];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

-(void)loadNumbers
{
    self.arrayOfNumbers = @[@5, @0, @25, @3, @44, @100, @55, @6, @7, @8];
    
    /*
     
     
     NSArray *sortedArray = [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
     
     if ([obj1 integerValue] > [obj2 integerValue]) {
     return (NSComparisonResult)NSOrderedDescending;
     }
     
     if ([obj1 integerValue] < [obj2 integerValue]) {
     return (NSComparisonResult)NSOrderedAscending;
     }
     return (NSComparisonResult)NSOrderedSame;
     }];
     
     */
}

// create initial array of employees
-(void)loadEmployees
{
    
    NSMutableArray *workingEmployeeList = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dFormat = [[NSDateFormatter alloc] init];
    [dFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    Employee *employee1 = [[Employee alloc] initWithFirstName:@"John"
                                                     lastName:@"Doe"
                                                   dateOfHire:[NSDate date] age:[NSNumber numberWithInt:34]];
    
    [workingEmployeeList addObject:employee1];

    Employee *employee2 = [[Employee alloc] initWithFirstName:@"Yan"
                                                     lastName:@"Smith"
                                                   dateOfHire:[dFormat dateFromString:@"2013-08-06T03:51:54+00:00"]
                                                          age:[NSNumber numberWithInt:44]];
    
    [workingEmployeeList addObject:employee2];
    
    Employee *employee3 = [[Employee alloc] initWithFirstName:@"Bob"
                                                     lastName:@"Nguyen"
                                                   dateOfHire:[dFormat dateFromString:@"2013-10-06T03:51:54+00:00"] age:[NSNumber numberWithInt:33]];
    [workingEmployeeList addObject:employee3];
    
    Employee *employee4 = [[Employee alloc] initWithFirstName:@"Alec"
                                                     lastName:@"Penguin"
                                                   dateOfHire:[dFormat dateFromString:@"2010-05-06T03:51:54+00:00"] age:[NSNumber numberWithInt:43]];
    [workingEmployeeList addObject:employee4];
    
    Employee *employee5 = [[Employee alloc] initWithFirstName:@"Jane"
                                                     lastName:@"Austen"
                                                   dateOfHire:[dFormat dateFromString:@"2001-04-06T03:51:54+00:00"]
                                                          age:[NSNumber numberWithInt:300]];
    [workingEmployeeList addObject:employee5];
    
    
    self.employees = [workingEmployeeList copy];
    
}

- (IBAction)orderByAgeBtnPressed:(id)sender {
    
    NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    
    NSArray *sortDescriptors = @[ageDescriptor];
    
    NSArray *sortedArray = [self.employees sortedArrayUsingDescriptors:sortDescriptors];
    self.employees = sortedArray;
  
    [self logEmployees];
    
}
- (IBAction)orderByHireDateBtnPressed:(id)sender {
    
    
    NSSortDescriptor *hireDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfHire" ascending:YES];
    NSArray *sortDescriptors = @[hireDateDescriptor];
    NSArray *sortedArrayByHireDate = [self.employees sortedArrayUsingDescriptors:sortDescriptors];
    
    self.employees = sortedArrayByHireDate;
    
    [self logEmployees];
}

- (IBAction)recreateButtonPressed:(id)sender {
    
    self.employees = nil;
    [self loadEmployees];
    
    [self logEmployees];
    
}

- (IBAction)sortByFirstName:(id)sender {
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[firstNameDescriptor];
    NSArray *sortedArray = [self.employees sortedArrayUsingDescriptors:sortDescriptors];
    self.employees = sortedArray;
    
    [self logEmployees];
}

- (IBAction)sortByAll:(id)sender {
    
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *dateHire = [[NSSortDescriptor alloc] initWithKey:@"dateOfHire" ascending:YES];
    NSSortDescriptor *age = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    
    NSArray *sortDescriptors = @[dateHire, age, lastNameDescriptor, firstNameDescriptor];
    
    NSArray *sortedArray = [self.employees sortedArrayUsingDescriptors:sortDescriptors];
    self.employees = sortedArray;
    
    [self logEmployees];
}

-(void)logEmployees
{
    NSLog(@"=============");
    
    for (int i =0; i < self.employees.count; i++)
    {
        Employee *thisEmployee = self.employees[i];
        NSLog(@"Employee: %@ age: %@ hire date: %@", thisEmployee.firstName, thisEmployee.age, thisEmployee.dateOfHire );
    }
}
@end
