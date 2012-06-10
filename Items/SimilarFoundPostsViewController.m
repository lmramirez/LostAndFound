//
//  SimilarFoundPostsViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimilarFoundPostsViewController.h"
#import "XMLReader.h"
#import "MyFoundItemViewController.h"

@implementation SimilarFoundPostsViewController
@synthesize childController;
@synthesize foundItems;
@synthesize xmlDataSoFar;
@synthesize searchResultsTableView;
@synthesize descriptionText;
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
    xmlDataSoFar = @"";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    xmlDataSoFar = @"";
    foundItems = [[NSMutableArray alloc] initWithObjects:nil];
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/query_similar_found_posts";
    //obtain user's unique ID
    NSArray *words = [descriptionText componentsSeparatedByString:@", "];
    NSString *one = [words objectAtIndex:0];
    NSString *two = [words objectAtIndex:1];
    //NSString *three = [words objectAtIndex:2];
    NSString *oneString = @"?one=";
    oneString = [oneString stringByAppendingString: one];
    url = [url stringByAppendingString:oneString];
    NSString *twoString = @"&two=";
    twoString = [twoString stringByAppendingString: two];
    url = [url stringByAppendingString:twoString];
    NSString *threeString = @"&three=";
    //threeString = [threeString stringByAppendingString: three];
    url = [url stringByAppendingString:threeString];
    NSLog(@"url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.searchResultsTableView setHidden:NO];
        
    
}


- (void)viewDidUnload
{
    [self setSearchResultsTableView:nil];
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
    
    self.xmlDataSoFar = @"";
    [self.searchResultsTableView reloadData];
    
    
}

#pragma mark-
#pragma mark Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.foundItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    if (row < [self.foundItems count]){
        cell.textLabel.text = [[self.foundItems objectAtIndex:row ] objectForKey:@"title"];
        cell.detailTextLabel.text = [[self.foundItems objectAtIndex:row ] objectForKey:@"timestamp"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    }
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(childController == nil){
        childController = [[MyFoundItemViewController alloc] initWithNibName:@"MyFoundItemViewController" bundle:nil];
    }
    
    childController.title = @"Found Item"; 
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
    childController->hasSendButton = YES;
    [self.navigationController pushViewController:childController animated:YES];
}




@end
