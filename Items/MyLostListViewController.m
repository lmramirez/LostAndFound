//
//  MyLostListViewController.m
//  Items
//
//  Created by Sophia
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyLostListViewController.h"
#import "MyLostItemViewController.h"
#import "XMLReader.h"
#import <Parse/Parse.h>



@implementation MyLostListViewController
@synthesize listData;
@synthesize searchResultsTableView;
@synthesize childController;
@synthesize foundItems;
@synthesize xmlDataSoFar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    self.title = @"My Lost Items";
    // Do any additional setup after loading the view from its nib.    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.listData = array;
    self.foundItems = [[NSMutableArray alloc] init];
    self.xmlDataSoFar = @"";
    [self getItems];
}

- (void)viewDidUnload
{
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

- (void)getItems {
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/query";
    BOOL first = YES;
    //obtain user's unique ID
    NSString * userID;
    NSArray *directory = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *rootD = [directory objectAtIndex:0];
    NSString *propertyFile = [rootD stringByAppendingPathComponent:@"userID.plist"];
    userID = [NSString stringWithContentsOfFile:propertyFile encoding: NSUTF8StringEncoding error:NULL ];
    if(userID) {
        //only query if the user has id
        
        url = [url stringByAppendingString:@"?isLost=true"];
        NSString *userIdString = @"&phoneId=";
        userIdString = [userIdString stringByAppendingString: userID];
        url = [url stringByAppendingString:userIdString];
        
        first = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.searchResultsTableView setHidden:NO];

    }
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
            if (itemTitle != nil){
                [itemStringsArray addObject:itemTitle]; 
            }else{
                [itemStringsArray addObject:@""]; 
            }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
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


    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(childController == nil){
        childController = [[MyLostItemViewController alloc] initWithNibName:@"MyLostItemViewController" bundle:nil];
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


//turns keyboard off when user hits return in textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//delete entry
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [searchResultsTableView setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //build url to delete entry in database
        NSUInteger row = [indexPath row];
        NSDictionary *selectedItem = [foundItems objectAtIndex:row];
        NSLog(@"selected item: %@", selectedItem);
        NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/delete?";
        BOOL first = YES;
        
        
        //delete image if there is one from Parse database
        NSString *photoId = [[self.foundItems objectAtIndex:row ] objectForKey:@"photoId"];
        if (photoId != nil){
            PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
            [query whereKey:@"imageName" equalTo:photoId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded
                    PFObject * newObj= [objects objectAtIndex:0];
                    [newObj deleteInBackground];
                } else {
                    // Log details of the failure
                }
            }];
        }
        
        //obtain user's unique ID
        if ([selectedItem objectForKey:@"phoneId"] != nil){
            NSString *userIdString = @"phoneId=";
            userIdString = [userIdString stringByAppendingString: [selectedItem objectForKey:@"phoneId"]];
            url = [url stringByAppendingString:userIdString];
            first = NO;
        }
        
        if ([selectedItem objectForKey:@"description"] != nil){
            NSString *descriptionString = @"description=";
            descriptionString = [descriptionString stringByAppendingString: [selectedItem objectForKey:@"description"]];
            if (!first){
                descriptionString = [@"&" stringByAppendingString:descriptionString];
            }
            url = [url stringByAppendingString:descriptionString];
            first = NO;
        }
        if ([selectedItem objectForKey:@"title"] != nil){
            NSString *nameString = @"title=";
            nameString = [nameString stringByAppendingString: [selectedItem objectForKey:@"title"]];
            if (!first){
                nameString = [@"&" stringByAppendingString:nameString];
            }
            url = [url stringByAppendingString:nameString];
            first = NO;
        }
        if ([selectedItem objectForKey:@"email"] != nil){
            NSString *emailString = @"email=";
            emailString = [emailString stringByAppendingString: [selectedItem objectForKey:@"email"]];
            if (!first){
                emailString = [@"&" stringByAppendingString:emailString];
            }
            url = [url stringByAppendingString:emailString];
            first = NO;
        }
        if ([selectedItem objectForKey:@"reward"] != nil){
            NSString *rewardString = @"reward=";
            rewardString = [rewardString stringByAppendingString: [selectedItem objectForKey:@"reward"]];
            if (!first){
                rewardString = [@"&" stringByAppendingString:rewardString];
            }
            url = [url stringByAppendingString:rewardString];
            first = NO;
        }
        if ([selectedItem objectForKey:@"zip"] != nil){
            NSString *zipCodeString = @"zip=";
            zipCodeString = [zipCodeString stringByAppendingString: [selectedItem objectForKey:@"zip"]];
            if (!first){
                zipCodeString = [@"&" stringByAppendingString:zipCodeString];
            }
            url = [url stringByAppendingString:zipCodeString];
            first = NO;
        }
        if ([selectedItem objectForKey:@"timestamp"] != nil){
            NSString *timeCodeString = @"timestamp=";
            timeCodeString = [timeCodeString stringByAppendingString: [selectedItem objectForKey:@"timestamp"]];
            if (!first){
                timeCodeString = [@"&" stringByAppendingString:timeCodeString];
            }
            url = [url stringByAppendingString:timeCodeString];
            first = NO;
        }
        
        if (!first){
            
            url = [url stringByAppendingString:@"&isLost=true"];
        }else{
            url = [url stringByAppendingString:@"isLost=true"];
            
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [foundItems removeObjectAtIndex:row];
        [self getItems];
        
    }
}

@end
