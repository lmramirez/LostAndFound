//
//  RootViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LostMenuViewController.h"
#import "FoundMenuViewController.h"
#import "MyMessagesViewController.h"
#import "RecentLostItemsViewController.h"
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@implementation RootViewController

//@synthesize mapView;
@synthesize lostMenuViewController;
@synthesize foundMenuViewController;
@synthesize myMessagesViewController;
@synthesize recentLostItemsViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
   
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
}


- (void)viewDidUnload
{

//    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    /**
    CLLocationCoordinate2D zoomLocation;
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
    //zoomLocation.latitude = 38.543332126932796;
    //zoomLocation.longitude = -121.74894332885742;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    **/
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)switchToLostItemMenu:(id)sender {
    if (!lostMenuViewController){
        lostMenuViewController = [[LostMenuViewController alloc] initWithNibName:@"LostMenuViewController" bundle:nil];
    }
    [self.navigationController pushViewController:lostMenuViewController animated:YES];
}

- (IBAction)switchToFoundItemMenu:(id)sender {
    if (!foundMenuViewController){
        foundMenuViewController = [[FoundMenuViewController alloc] initWithNibName:@"FoundMenuViewController" bundle:nil];
    }
    [self.navigationController pushViewController:foundMenuViewController animated:YES];

}

- (IBAction)switchToMyMessages:(id)sender {
    if (!myMessagesViewController){
        myMessagesViewController = [[MyMessagesViewController alloc] initWithNibName:@"MyMessagesViewController" bundle:nil];
    }
    [self.navigationController pushViewController:myMessagesViewController animated:YES];

}
- (IBAction)switchToRecentLostItems:(id)sender {
    if (!recentLostItemsViewController){
        recentLostItemsViewController = [[RecentLostItemsViewController alloc] initWithNibName:@"RecentLostItemsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:recentLostItemsViewController animated:YES];
}
@end
