//
//  FoundItemViewController.m
//  Items
//
//  Created by Luis Ramirez on 3/3/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "FoundItemViewController.h"
#import <Parse/Parse.h>
#import "SendMessageViewController.h"
#import "ItemOnMapViewController.h"
@implementation FoundItemViewController
@synthesize image;
@synthesize scrollView;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize emailLabel;
@synthesize zipcodeLabel;
@synthesize rewardLabel;
@synthesize createdAtLabel;
@synthesize backgroundImage;
@synthesize mapButton;
@synthesize createdAtText;
@synthesize sendMessageViewController;
@synthesize itemOnMapViewController;
@synthesize latitude,longitude;
@synthesize titleText, descriptionText, emailText, zipcodeText, rewardText, photoId, phoneId;

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
    
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    //[scrollView setBackgroundColor:[UIColor whiteColor]];
    self.backgroundImage.frame = CGRectMake(-13, -24, 340, 689);
    [scrollView setContentSize:CGSizeMake(320, 850)];
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

- (IBAction)sendMessageButton:(id)sender {
    if (sendMessageViewController == nil){
        sendMessageViewController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    }
    sendMessageViewController.titleText = titleText;
    sendMessageViewController.toUid = phoneId;
    [self.navigationController pushViewController:sendMessageViewController animated:YES];
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
