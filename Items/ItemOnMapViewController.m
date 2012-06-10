//
//  ItemOnMapViewController.m
//  Items
//
//  Created by Sophia on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemOnMapViewController.h"
#import <MapKit/Mapkit.h>
@implementation ItemOnMapViewController
@synthesize mapView;
@synthesize itemLocation;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MKCoordinateRegion region;
    region.center = itemLocation;  
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate=itemLocation;
    [self.mapView addAnnotation:point];
    MKCoordinateSpan span; 
    span.latitudeDelta  = 0.05; // Change these values to change the zoom
    span.longitudeDelta = 0.05; 
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) resetLocation
{
    [mapView removeAnnotations:mapView.annotations];
    MKCoordinateRegion region;
    region.center = itemLocation;  
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate=itemLocation;
    [self.mapView addAnnotation:point];
    MKCoordinateSpan span; 
    span.latitudeDelta  = 0.05; // Change these values to change the zoom
    span.longitudeDelta = 0.05; 
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

@end
