//
//  MyMessagesViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyMessagesViewController.h"
#import "XMLReader.h"
#import "MessageDetailViewController.h"
#import "SentBoxViewController.h"

@implementation MyMessagesViewController
@synthesize  xmlDataSoFar;
@synthesize messageList;
@synthesize messagesTableView;
@synthesize titleList;
@synthesize messageDetailViewController;
@synthesize sentBoxViewController;
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
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"Sent Box"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goToSentBox:)]; 
    [self.navigationItem setRightBarButtonItem:myButton];
}

- (void)viewDidUnload
{
    [self setMessagesTableView:nil];
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
    NSArray *itemsArray = [[dictionary objectForKey:@"messages"] objectForKey:@"message"]; 
    NSMutableArray *itemStringsArray = [[NSMutableArray alloc] init];
    
    
    if([itemsArray isKindOfClass:[NSArray class]]){
              
        for(int i=0; i < [itemsArray count]; i++){
            NSDictionary *currentItem = [itemsArray objectAtIndex:i];
            NSString *itemTitle = [currentItem objectForKey:@"postTitle"];
            
            [self.messageList addObject:currentItem];
            if (itemTitle != nil){
                [itemStringsArray addObject:itemTitle]; 
            }else{
                [itemStringsArray addObject:@""]; 
            }
        } 
        
    }
    
    else {
        
        NSDictionary *currentItem = [[dictionary objectForKey:@"messages"] objectForKey:@"message"];
        if (currentItem != nil) {
            NSString *itemTitle = [currentItem objectForKey:@"postTitle"];
            
            [self.messageList addObject:currentItem];
            if (itemTitle != nil){
                [itemStringsArray addObject:itemTitle]; 
            }else{
                [itemStringsArray addObject:@""]; 
            }
        }
    } 
    
    if (messageList == nil){
        messageList = [[NSMutableArray alloc] initWithObjects:nil];
    }
    self.titleList = itemStringsArray;
    self.xmlDataSoFar = @"";
    [self.messagesTableView reloadData];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
       
    }
   
    
    if ([self.messageList count] != 0){
        NSUInteger row = [indexPath row];
        cell.textLabel.text = [[self.messageList objectAtIndex:row ] objectForKey:@"postTitle"];
        cell.detailTextLabel.text = [[self.messageList objectAtIndex:row ] objectForKey:@"createdAt"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSUInteger row = [indexPath row];
    if (messageDetailViewController == nil){
        messageDetailViewController = [[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil];
    }
    messageDetailViewController.titleText = [[self.messageList objectAtIndex:row ] objectForKey:@"postTitle"];
    messageDetailViewController.descriptionText = [[self.messageList objectAtIndex:row ] objectForKey:@"messageText"];
    messageDetailViewController.dateText = [[self.messageList objectAtIndex:row ] objectForKey:@"createdAt"];
    messageDetailViewController.fromUidString = [[self.messageList objectAtIndex:row ] objectForKey:@"fromUid"];
    messageDetailViewController.toUidString = [[self.messageList objectAtIndex:row ] objectForKey:@"toUid"];
    messageDetailViewController->showButton = YES;
    [self.navigationController pushViewController:messageDetailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"Inbox";
    if (messageList == nil){
        messageList = [[NSMutableArray alloc] initWithObjects:nil];
    }else {
        [messageList removeAllObjects];
    }
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/message/query";
    NSString * userID;
    NSArray *directory = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *rootD = [directory objectAtIndex:0];
    xmlDataSoFar = @"";
    NSString *propertyFile = [rootD stringByAppendingPathComponent:@"userID.plist"];
    userID = [NSString stringWithContentsOfFile:propertyFile encoding: NSUTF8StringEncoding error:NULL ];
    if(userID) {
        NSString *toUIdString = @"?toUid=";
        toUIdString = [toUIdString stringByAppendingString: userID];
        url = [url stringByAppendingString:toUIdString];
    }
    else
    {
        //load new User ID into plist
        CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
        [uniqueID writeToFile:propertyFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        CFRelease(uniqueRef);
    }
  
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)goToSentBox:(id)sender{
    if (self.sentBoxViewController == nil){
        self.sentBoxViewController = [[SentBoxViewController alloc] init];
        
    }
    [self.navigationController pushViewController:sentBoxViewController animated:YES];
}




@end
