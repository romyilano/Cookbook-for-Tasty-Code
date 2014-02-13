//
//  ViewController.m
//  World Map Location
//
//  Created by Romy Ilano on 2/13/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.delegate = self;
    
    // set up region of the map view
    CLLocationCoordinate2D baltimoreLocation = CLLocationCoordinate2DMake(39.303, -76.612);
    self.mapView.region = MKCoordinateRegionMakeWithDistance(baltimoreLocation, 10000, 10000);
    
    // optional controls
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    // Control user location on the map
    if ([CLLocationManager locationServicesEnabled])
    {
        self.mapView.showsUserLocation = YES;
        // can set up the mode to follow user, keeping location in the center.
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        /*
         Note:
         Just because showUserLocation is set to YES the user's location is not automatically
         visible on the map. To determine whether the location is visible in the current region,
         use the property userLocationVisible
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMap Delegate Methods
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userLocationLabel.text = [NSString stringWithFormat:@"Current location: %.5f, %.5f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
}


@end
