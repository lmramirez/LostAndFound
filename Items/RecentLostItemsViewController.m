//
//  RecentLostItems.m
//  Items
//
//  Created by Luis Ramirez on 3/11/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "RecentLostItemsViewController.h"
#import "FoundItemViewController.h"
#import "XMLReader.h"

#define SECONDS_IN_WEEK 604800



@interface RecentLostItemsViewController() 
@property (strong, nonatomic) FoundItemViewController *childController;
-(BOOL) isRecent:(id)itemDate;
@end

@implementation RecentLostItemsViewController
@synthesize recentLostTable;
@synthesize listData;
@synthesize currentZip;
@synthesize childController;
@synthesize foundItems;
@synthesize xmlDataSoFar;
@synthesize locationManager;
@synthesize recentLostMapViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 80.0;
        [self.locationManager startUpdatingLocation];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //NSLog(@"zip: %@", [placemark postalCode]);
            self.currentZip = [placemark postalCode];
            [self viewWillAppear:YES];
            
        }];
        
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
    //[self.searchTextField setText:nil];
    // Do any additional setup after loading the view from its nib.    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.listData = array;
    self.foundItems = [[NSMutableArray alloc] init];
    self.xmlDataSoFar = @"";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"Map View" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToMap:)];
    
    [self.navigationItem setRightBarButtonItem:myButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.currentZip){
        NSLog(@"currentZip: %@", self.currentZip);
        NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/query";
        BOOL first = YES;
        //NSLog(@"%@", [self.searchTextField text]);
        if (self.currentZip != nil){
            NSString *zipString = @"?zip=";
            zipString = [zipString stringByAppendingString:self.currentZip];
            url = [url stringByAppendingString:zipString];
            //NSLog(@"%@", url);
            first = NO;
            
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        //self.searchTextField.text = nil;
        [self.recentLostTable setHidden:NO];
        //[searchTextField resignFirstResponder];
    }
   
}

- (void)viewDidUnload
{
    //[self setSearchTextField:nil];
    
    //[self searchResultsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listData = nil;
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
    NSDictionary *dictionary = [XMLReader dictionaryForXMLString:self.xmlDataSoFar error:nil];
    NSArray *itemsArray = [[dictionary objectForKey:@"items"] objectForKey:@"item"]; 
    NSMutableArray *itemStringsArray = [[NSMutableArray alloc] init];
    
    
    if([itemsArray isKindOfClass:[NSArray class]]){
        NSLog(@"MULTIPLE RESULT");        
        for(int i=0; i < [itemsArray count]; i++){
            NSDictionary *currentItem = [itemsArray objectAtIndex:i];
            NSString *itemTitle = [currentItem objectForKey:@"title"];
            NSLog(@"%@", itemTitle);
            [foundItems addObject:currentItem];
            if (itemTitle != nil && [self isRecent:[currentItem objectForKey:@"timestamp"]]){
                [itemStringsArray addObject:itemTitle]; 
            }/*else{
              [itemStringsArray addObject:@""]; 
              }*/
        } 
        NSLog(@"found items: %@", foundItems);
    }
    
    else {
        NSLog(@"SINGLE RESULT");
        NSDictionary *currentItem = [[dictionary objectForKey:@"items"] objectForKey:@"item"];
        if (currentItem != nil) {
            NSString *itemTitle = [currentItem objectForKey:@"title"];
            NSLog(@"%@", itemTitle);
            [foundItems addObject:currentItem];
            if (itemTitle != nil && [self isRecent:[currentItem objectForKey:@"timestamp"]]){
                [itemStringsArray addObject:itemTitle]; 
            }/*else{
              [itemStringsArray addObject:@""]; 
              }*/
        }
    } 
    
    self.listData = itemStringsArray;
    //NSLog(@"here: %@", self.listData);
    self.xmlDataSoFar = @"";
    [self.recentLostTable reloadData];
    
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

#pragma mark-
#pragma mark Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d", [self.listData count]);
    return [self.listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(childController == nil){
        childController = [[FoundItemViewController alloc] initWithNibName:@"FoundItemViewController" bundle:nil];
    }
    
    childController.title = @"Lost Item"; 
    NSUInteger row = [indexPath row];
    NSDictionary *selectedItem = [foundItems objectAtIndex:row];
    NSLog(@"selected item: %@", selectedItem);
    
    childController.descriptionText = [selectedItem objectForKey:@"description"];
    childController.emailText = [selectedItem objectForKey:@"email"];
    childController.zipcodeText = [selectedItem objectForKey:@"zip"];
    childController.titleText = [selectedItem objectForKey:@"title"];
    childController.rewardText = [selectedItem objectForKey:@"reward"];
    childController.photoId = [selectedItem objectForKey:@"photoId"];
    childController.createdAtText = [selectedItem objectForKey:@"timestamp"];
    childController.latitude = [selectedItem objectForKey:@"latitude"];
    childController.longitude = [selectedItem objectForKey:@"longitude"];
    [self.navigationController pushViewController:childController animated:YES];
}

-(IBAction)switchToMap:(id)sender {
    if (!recentLostMapViewController){
        recentLostMapViewController = [[RecentLostMapViewController alloc] initWithNibName:@"RecentLostMapViewController" bundle:nil];
    }
    [self.navigationController pushViewController:recentLostMapViewController animated:YES];
}

@end

