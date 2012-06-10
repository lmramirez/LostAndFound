//
//  MyLostItemViewController.m
//  Items
//
//  
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "MyLostItemViewController.h"
#import "SimilarFoundPostsViewController.h"
#import "ItemOnMapViewController.h"
#import <Parse/Parse.h>
@implementation MyLostItemViewController

@synthesize image;
@synthesize scrollView;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize emailLabel;
@synthesize zipcodeLabel;
@synthesize rewardLabel;
@synthesize createdAtLabel;
@synthesize mapButton;
@synthesize backgroundImage;
@synthesize createdAtText;
@synthesize latitude, longitude;
@synthesize similarFoundPostsViewController;
@synthesize itemOnMapViewController;

@synthesize titleText, descriptionText, emailText, zipcodeText, rewardText, photoId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titleText = @"";
        descriptionText = @"";
        emailText = @"";
        zipcodeText = @"";
        rewardText = @"";
        latitude = @"";
        longitude = @"";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{      //---set the content size of the scroll view---
   
    //---set the content size of the scroll view---
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    self.backgroundImage.frame = CGRectMake(-13, -24, 340, 725);
    [scrollView setContentSize:CGSizeMake(320, 900)];
}


-(void)viewWillAppear:(BOOL)animated{
    
    titleLabel.text = titleText;
    descriptionLabel.text = descriptionText;
    emailLabel.text = emailText;
    zipcodeLabel.text = zipcodeText;
    rewardLabel.text = rewardText;
    createdAtLabel.text = createdAtText;

    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    if (photoId != nil){
        [query whereKey:@"imageName" equalTo:self.photoId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                PFObject * newObj= [objects objectAtIndex:0];
                PFFile *newImageFile = [newObj objectForKey:@"imageFile"];
                NSData *newImageData = [newImageFile getData];
                UIImage * newImage = [UIImage imageWithData: newImageData];
                [self.image setImage:newImage]; 
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }else{
         [self.image setImage:nil]; 
    }
    if ([latitude isEqualToString:@""] || [longitude isEqualToString:@""])
    {
        mapButton.hidden = YES;
    }
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    
    self.titleLabel = nil;
    self.descriptionLabel = nil;
    self.emailLabel = nil;
    self.zipcodeLabel = nil;
    self.rewardLabel = nil;
    
    
    [self setImage:nil];
    [self setCreatedAtText:nil];
    [self setCreatedAtLabel:nil];
    [self setBackgroundImage:nil];
    [self setMapButton:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)similarFoundPostsButton:(id)sender {
    if (similarFoundPostsViewController == nil){
        similarFoundPostsViewController = [[SimilarFoundPostsViewController alloc] initWithNibName:@"SimilarFoundPostsViewController" bundle:nil];
    }
    similarFoundPostsViewController.descriptionText = descriptionText;
    [self.navigationController pushViewController:similarFoundPostsViewController animated:YES];                                      
}

- (IBAction)locationMap:(id)sender {
    if (itemOnMapViewController == nil){
        itemOnMapViewController = [[ItemOnMapViewController alloc] initWithNibName:@"ItemOnMapViewController" bundle:nil];
    }
    CLLocationCoordinate2D tempLocation;
    tempLocation.latitude = [latitude floatValue];
    tempLocation.longitude = [longitude floatValue];
    itemOnMapViewController.itemLocation = tempLocation;
    [itemOnMapViewController resetLocation];
    [self.navigationController pushViewController:itemOnMapViewController animated:YES];
}
@end
