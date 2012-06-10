//
//  RecentLostMapViewController.m
//  Items
//
//  Created by Luis Ramirez on 3/19/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//
//Referenced http://www.raywenderlich.com/2847/introduction-to-mapkit-on-ios-tutorial 
//

#import "RecentLostMapViewController.h"
#import "FoundItemViewController.h"
#define METERS_PER_MILE 1609.344
#define SECONDS_IN_WEEK 604800


@interface RecentLostMapViewController() 
@property (strong, nonatomic) FoundItemViewController *childController;
@end

@implementation RecentLostMapViewController
@synthesize mapView;
@synthesize xmlDataSoFar;
@synthesize foundItems;
@synthesize childController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.foundItems = [[NSMutableArray alloc] init];
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
    /*[self.mapView.userLocation addObserver:self 
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];*/
    self.foundItems = [[NSMutableArray alloc] init];
    self.xmlDataSoFar = @"";
}

- (void)viewWillAppear:(BOOL)animated{
    CLLocationCoordinate2D zoomLocation;
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    mapView.showsUserLocation = YES;
    [mapView setRegion:adjustedRegion animated:YES];
    
    
    //Get Stuff
    
   // if(self.currentZip){
     //   NSLog(@"currentZip: %@", self.currentZip);
        NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/query";
        BOOL first = YES;
        //NSLog(@"%@", [self.searchTextField text]);
       // if (self.currentZip != nil){
         //   NSString *urlString = @"?zip=";
         //   zipString = [urlString stringByAppendingString:self.currentZip];
         //   url = [url stringByAppendingString:urlString];
            //NSLog(@"%@", url);
            first = NO;
            
        //}
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        //self.searchTextField.text = nil;
        //[self.recentLostTable setHidden:NO];
        //[searchTextField resignFirstResponder];
   // }
    
    
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


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    xmlDataSoFar = [xmlDataSoFar stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //self.foundItems = [[NSMutableArray alloc] init];

    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLString:self.xmlDataSoFar error:nil];
    NSArray *itemsArray = [[dictionary objectForKey:@"items"] objectForKey:@"item"]; 
    NSLog(@"itemsArray: %@", itemsArray);
    //NSMutableArray *itemStringsArray = [[NSMutableArray alloc] init];
    
    
/*    if([itemsArray isKindOfClass:[NSArray class]]){
        NSLog(@"MULTIPLE RESULT");        
        for(int i=0; i < [itemsArray count]; i++){
            NSDictionary *currentItem = [itemsArray objectAtIndex:i];
            //NSString *itemTitle = [currentItem objectForKey:@"title"];
            //NSLog(@"%@", itemTitle);

            if ([self isRecent:[currentItem objectForKey:@"timestamp"]]){
                [foundItems addObject:currentItem]; 
            }
        } 
        NSLog(@"found items: %@", foundItems);
    }
    
    else {
        NSLog(@"SINGLE RESULT");
        NSDictionary *currentItem = [[dictionary objectForKey:@"items"] objectForKey:@"item"];
        if (currentItem != nil) {
            //NSString *itemTitle = [currentItem objectForKey:@"title"];
            //NSLog(@"%@", itemTitle);
            if ([self isRecent:[currentItem objectForKey:@"timestamp"]]){
                 [foundItems addObject:currentItem];
            }
            
        }
    } 
*/    
    for(int i=0; i < [itemsArray count]; i++){
        NSDictionary *currentItem = [itemsArray objectAtIndex:i];
        NSLog(@"longitude: %@", [currentItem objectForKey:@"longitude"]);
        if([currentItem objectForKey:@"longitude"] && [[currentItem objectForKey:@"isLost"] isEqualToString:@"true"]){
            [self.foundItems addObject:currentItem];
            NSLog(@"currentItem: %@", currentItem);
        }
    }
    //self.listData = itemStringsArray;
    //self.foundItems = itemsArray;
    //[self.foundItems addObject:@"some stuff"];
    NSLog(@"foundItems: %@", self.foundItems);
    self.xmlDataSoFar = @"";
    //[self.recentLostTable reloadData];
    [self plotLostItems];
    
}

-(BOOL) isRecent:(id)itemDate{
    NSLog(@"itemDate: %@", itemDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:itemDate];
    NSTimeInterval timeSinceNow = [date timeIntervalSinceNow];
    NSLog(@"time since now: %f", timeSinceNow);
    if(-SECONDS_IN_WEEK < timeSinceNow){
        return TRUE;
    }
    else
        return FALSE;
}


- (void)plotLostItems {
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    
    int count = 0;
    for (NSDictionary * item in foundItems) {
        
        NSNumber * latitude = [item objectForKey:@"latitude"];
        NSNumber * longitude = [item objectForKey:@"longitude"];
        NSString * title = [item objectForKey:@"title"];
        if(!title){
            title = @"title";

        }
        NSString * subTitle = [item objectForKey:@"description"];
        if(!subTitle){
            subTitle = @"subtitle";
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;            


      
        
        LostItemAnnotation *annotation = [[LostItemAnnotation alloc] initWithName:title subtitle:subTitle coordinate:coordinate];
        annotation.arrayPosition = count;
        NSLog(@"annotation.name: %@", annotation.title);
        count++;
        [mapView addAnnotation:annotation];    
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"LostItemAnnotation";   
    if ([annotation isKindOfClass:[LostItemAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(goToItemDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        LostItemAnnotation *curAnn = annotation;
        rightButton.tag = curAnn.arrayPosition;
        
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.animatesDrop = YES;
        //annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;    
}


-(IBAction)goToItemDetail:(id)sender {
    if(childController == nil){
        childController = [[FoundItemViewController alloc] initWithNibName:@"FoundItemViewController" bundle:nil];
    }
    
    UIButton *selectedButton = sender;
    NSLog(@"sendertag: %d", selectedButton.tag);
   
    childController.title = @"Lost Item"; 
    //NSUInteger row = [indexPath row];
    NSDictionary *selectedItem = [foundItems objectAtIndex:selectedButton.tag];
    NSLog(@"selected item: %@", selectedItem);
    
    childController.descriptionText = [selectedItem objectForKey:@"description"];
    childController.emailText = [selectedItem objectForKey:@"email"];
    childController.zipcodeText = [selectedItem objectForKey:@"zip"];
    childController.titleText = [selectedItem objectForKey:@"title"];
    childController.rewardText = [selectedItem objectForKey:@"reward"];
    childController.photoId = [selectedItem objectForKey:@"photoId"];
    childController.createdAtText = [selectedItem objectForKey:@"timestamp"];
    [self.navigationController pushViewController:childController animated:YES];
    
    
}





@end
