//
//  ViewController.m
//  Stubborn
//
//  Created by Romy Ilano on 1/27/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(void)savePersistentData:(id)sender;
-(void)loadPersistentData:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    
    [self loadPersistentData:self];
                                        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(savePersistentData:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleActivity:(id)sender {
    
    if (self.activitySwitch.on)
    {
        [self.activityIndicator startAnimating];
    }
    else
    {
        [self.activityIndicator stopAnimating];
    }
}

-(void)savePersistentData:(id)sender
{
    // You can also use NSUserDefault resetStandardUserDefaults to clear all data
    //      that's previously stored. This is a good way to reset your app to its standard
    //      settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // set objects/values to persist
    [userDefaults setObject:self.firstNameTextField.text forKey:@"firstName"];
    [userDefaults setObject:self.lastNameTextField.text forKey:@"lastName"];
    [userDefaults setBool:self.activitySwitch.on forKey:@"activityOn"];
    
    // save changes
    [userDefaults synchronize];
}

-(void)loadPersistentData:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.firstNameTextField.text = [userDefaults objectForKey:@"firstName"];
    self.lastNameTextField.text = [userDefaults objectForKey:@"lastName"];
    // note that this is how a bool is summoned
    [self.activitySwitch setOn:[userDefaults boolForKey:@"activityOn"] animated:NO];
    
    if (self.activitySwitch.on)
    {
        [self.activityIndicator startAnimating];
    }
}
@end
