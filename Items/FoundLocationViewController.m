//
//  FoundLocationViewController.m
//  Items
//
//  Created by Sophia on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Works cited :
/*  http://stackoverflow.com/questions/2473706/how-do-i-zoom-an-mkmapview-to-the-users-current-location-without-cllocationmanag
*   http://freshmob.com.au/mapkit/mapkit-tap-and-hold-to-drop-a-pin-on-the-map/
 */
#import "FoundLocationViewController.h"
#import "CreateFoundPostViewController.h"



@implementation FoundLocationViewController
@synthesize mapView;
@synthesize currentPoint;
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
 //zoom to user's current location
       [self.mapView.userLocation addObserver:self 
                        forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
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

// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{       
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;  
    
    MKCoordinateSpan span; 
    span.latitudeDelta  = 1; // Change these values to change the zoom
    span.longitudeDelta = 1; 
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

//create pin if user presses down for long press
-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {

    if(!currentPoint)
    {
        currentPoint = [[MKPointAnnotation alloc] init]; //initialize if first time
    }
    else [self.mapView removeAnnotation:currentPoint]; //remove previous pin
    
    //obtain and put point on map
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D currentCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    currentPoint.coordinate=currentCoordinate;
     
    [self.mapView addAnnotation:currentPoint];
    
    CreateFoundPostViewController * viewControl = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    viewControl.locationLabel.text = [NSString stringWithFormat:@"Location: %f, %f",currentCoordinate.latitude, currentCoordinate.longitude]; 
    viewControl.itemCoordinate = currentCoordinate;
    viewControl.gotCoordinate = true;

}


@end
