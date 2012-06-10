//
//  MyFoundItemViewController.m
//  Items
//
//  
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "MyFoundItemViewController.h"
#import <Parse/Parse.h>
#import "SendMessageViewController.h"
#import "ItemOnMapViewController.h"
@implementation MyFoundItemViewController

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize emailLabel;
@synthesize zipcodeLabel;
@synthesize rewardLabel;
@synthesize createdAtLabel;
@synthesize backgroundImage;
@synthesize mapButton;
@synthesize sendMessage;
@synthesize createdAtText;
@synthesize sendMessageViewController;
@synthesize itemOnMapViewController;
@synthesize phoneId;
@synthesize latitude, longitude;
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
    
    [super viewDidLoad];

    //[scrollView setBackgroundColor:[UIColor whiteColor]];


}


-(void)viewWillAppear:(BOOL)animated{
    
    titleLabel.text = titleText;
    descriptionLabel.text = descriptionText;
    emailLabel.text = emailText;
    zipcodeLabel.text = zipcodeText;
    rewardLabel.text = rewardText;
    createdAtLabel.text = createdAtText;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    if (hasSendButton == NO){
        sendMessage.hidden = YES;
    }
    if ([latitude isEqualToString:@""] || [longitude isEqualToString:@""])
    {
        mapButton.hidden = YES;
    }
    //[descriptionLabel sizeToFit];
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    
    self.titleLabel = nil;
    self.descriptionLabel = nil;
    self.emailLabel = nil;
    self.zipcodeLabel = nil;
    self.rewardLabel = nil;
    
    [self setCreatedAtText:nil];
    [self setCreatedAtLabel:nil];
    [self setBackgroundImage:nil];
    [self setSendMessage:nil];
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

- (IBAction)locationView:(id)sender {
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
