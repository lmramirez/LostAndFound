//
//  SendMessageViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendMessageViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SendMessageViewController
@synthesize messageTextView;
@synthesize titleLabel;
@synthesize titleText;
@synthesize toUid;
@synthesize postId;

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
    [[self.messageTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.messageTextView layer] setBorderWidth:2.0];
    [[self.messageTextView layer] setCornerRadius:10];  
    [self.messageTextView setEnablesReturnKeyAutomatically:YES];
    [titleLabel setText:titleText];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)sendButton:(id)sender {
    //obtain user's unique ID
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/message/create?";
    NSString * userID;
    NSArray *directory = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *rootD = [directory objectAtIndex:0];
    NSString *propertyFile = [rootD stringByAppendingPathComponent:@"userID.plist"];
    userID = [NSString stringWithContentsOfFile:propertyFile encoding: NSUTF8StringEncoding error:NULL ];
    if(userID) {
        NSString *userIdString = @"fromUid=";
        userIdString = [userIdString stringByAppendingString: userID];
        url = [url stringByAppendingString:userIdString];
        
    }
    else
    {
        //load new User ID into plist
        CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
        [uniqueID writeToFile:propertyFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        CFRelease(uniqueRef);
    }
    
    if (titleText != nil){
        NSString *titleString = @"postTitle=";
        titleString = [titleString stringByAppendingString: titleText];
        titleString = [@"&" stringByAppendingString:titleString];
        url = [url stringByAppendingString:titleString];
    }
    
    if (toUid != nil){
        NSString *toUidString = @"toUid=";
        toUidString = [toUidString stringByAppendingString: toUid];
        toUidString = [@"&" stringByAppendingString:toUidString];
        url = [url stringByAppendingString:toUidString];
    }
    if ([messageTextView text] != nil){
        NSString *messageTextString = @"messageText=";
        messageTextString = [messageTextString stringByAppendingString: [messageTextView text]];
        messageTextString = [@"&" stringByAppendingString:messageTextString];
        url = [url stringByAppendingString:messageTextString];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent" 
                                                    message:@"Your message has been sent"
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.navigationController popViewControllerAnimated:YES];   
}

@end
