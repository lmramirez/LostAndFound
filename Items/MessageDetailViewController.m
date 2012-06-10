//
//  MessageDetailViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "SendMessageViewController.h"

@implementation MessageDetailViewController
@synthesize sendMessageViewController;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize titleText;
@synthesize descriptionText;
@synthesize dateText;
@synthesize toUidString;
@synthesize fromUidString;
@synthesize replyUIButton;


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
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setReplyUIButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    if (showButton == NO){
        replyUIButton.hidden = YES;
    }
    titleLabel.text = titleText;
    descriptionLabel.text = descriptionText;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    dateLabel.text = dateText;
    [super viewWillAppear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)replyButton:(id)sender {
    if (sendMessageViewController == nil){
        sendMessageViewController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    }
    sendMessageViewController.titleText = titleText;
    sendMessageViewController.toUid = toUidString;
    
    [self.navigationController pushViewController:sendMessageViewController animated:YES];
}


@end
