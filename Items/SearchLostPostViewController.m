//
//  SearchLostPostViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchLostPostViewController.h"
#import "FoundItemViewController.h"
#import "XMLReader.h"
#import <Parse/Parse.h>

@interface SearchLostPostViewController() 
@property (strong, nonatomic) FoundItemViewController *childController;
@end

@implementation SearchLostPostViewController
@synthesize searchResultsTableView;
@synthesize searchTextField;
@synthesize listData;
@synthesize childController;
@synthesize foundItems;
@synthesize xmlDataSoFar;

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
    [self.searchTextField setText:nil];
    // Do any additional setup after loading the view from its nib.    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.listData = array;
    self.foundItems = [[NSMutableArray alloc] init];
    self.xmlDataSoFar = @"";
}

- (void)viewDidUnload
{
    [self setSearchTextField:nil];
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

- (IBAction)searchButton:(id)sender {
    xmlDataSoFar = @""; //reset xmlData string
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/query";
    BOOL first = YES;
   
    if ([self.searchTextField text] != nil){
        NSString *descriptionString = @"?description=";
        descriptionString = [descriptionString stringByAppendingString: [self.searchTextField text]];
        url = [url stringByAppendingString:descriptionString];
        url = [url stringByAppendingString:@"&isLost=true"];
        first = NO;
        
    }else{
        url = [url stringByAppendingString:@"?isLost=true"];    
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.searchTextField.text = nil;
    [self.searchResultsTableView setHidden:NO];
    [searchTextField resignFirstResponder];
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
        
        for(int i=0; i < [itemsArray count]; i++){
            NSDictionary *currentItem = [itemsArray objectAtIndex:i];
            NSString *itemTitle = [currentItem objectForKey:@"title"];

            [foundItems addObject:currentItem];
            if (itemTitle != nil){
                [itemStringsArray addObject:itemTitle]; 
            }else{
                [itemStringsArray addObject:@""]; 
            }
        } 

    }
    
    else {
         NSDictionary *currentItem = [[dictionary objectForKey:@"items"] objectForKey:@"item"];
        if (currentItem != nil) {
            NSString *itemTitle = [currentItem objectForKey:@"title"];
 
            [foundItems addObject:currentItem];
            if (itemTitle != nil){
                [itemStringsArray addObject:itemTitle]; 
            }else{
                [itemStringsArray addObject:@""]; 
            }
        }
    } 
    
    self.listData = itemStringsArray;
    self.xmlDataSoFar = @"";
    [self.searchResultsTableView reloadData];

    
}

#pragma mark-
#pragma mark Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:SimpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.foundItems objectAtIndex:row ] objectForKey:@"title"];
    cell.detailTextLabel.text = [[self.foundItems objectAtIndex:row ] objectForKey:@"timestamp"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
    NSString *photoId = [[self.foundItems objectAtIndex:row ] objectForKey:@"photoId"];
    if (photoId != nil){
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query whereKey:@"imageName" equalTo:photoId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                PFObject * newObj= [objects objectAtIndex:0];
                PFFile *newImageFile = [newObj objectForKey:@"imageFile"];
                NSData *newImageData = [newImageFile getData];
                UIImage * newImage = [UIImage imageWithData: newImageData];
                cell.imageView.image = newImage;
            } else {
                // Log details of the failure
            }
        }];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"pictureNotAvailable.png"];
    }
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
    
    childController.descriptionText = [selectedItem objectForKey:@"description"];
    childController.emailText = [selectedItem objectForKey:@"email"];
    childController.zipcodeText = [selectedItem objectForKey:@"zip"];
    childController.titleText = [selectedItem objectForKey:@"title"];
    childController.rewardText = [selectedItem objectForKey:@"reward"];
    childController.photoId = [selectedItem objectForKey:@"photoId"];
    childController.createdAtText = [selectedItem objectForKey:@"timestamp"];
    childController.phoneId = [selectedItem objectForKey:@"phoneId"];
    childController.latitude = [selectedItem objectForKey:@"latitude"];
    childController.longitude = [selectedItem objectForKey:@"longitude"];
    [self.navigationController pushViewController:childController animated:YES];
}


//turns keyboard off when user hits return in textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
