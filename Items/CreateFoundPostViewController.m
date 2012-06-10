//
//  CreateFoundPostViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateFoundPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FoundLocationViewController.h"
@implementation CreateFoundPostViewController
@synthesize descriptionTextView;
@synthesize backgroundImage;
@synthesize descriptionTextViewRequired;
@synthesize scrollView;
@synthesize itemtitle;
@synthesize email;
@synthesize zipCode;
@synthesize currentField;
@synthesize foundLocationViewController;
@synthesize locationLabel;
@synthesize itemCoordinate;
@synthesize gotCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self registerForKeyboardNotifications];
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
    keyBoardSize = CGSizeMake(0, 0);
    // Do any additional setup after loading the view from its nib.
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //---set the content size of the scroll view---
    //[scrollView setContentMode:UIViewContentModeScaleAspectFit];
    //[self.backgroundImage sizeToFit];
    self.backgroundImage.frame = CGRectMake(0.0, 0.0, 320, 680);
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+150)]; 
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:2.0];
    [[self.descriptionTextView layer] setCornerRadius:10];  
    [self.descriptionTextView setEnablesReturnKeyAutomatically:YES];
    
    //initialize gotCoordinate boolean
    gotCoordinate = false; //did not get coordinate yet
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setDescriptionTextViewRequired:nil];
    [self setBackgroundImage:nil];
    [self setDescriptionTextView:nil];

    [self setScrollView:nil];
    [self setZipCode:nil];
    [self setEmail:nil];
    [self setItemtitle:nil];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





- (IBAction)makePost:(id)sender {
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/create?";
    BOOL first = YES;
    //obtain user's unique ID
    NSString * userID;
    NSArray *directory = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *rootD = [directory objectAtIndex:0];
    NSString *propertyFile = [rootD stringByAppendingPathComponent:@"userID.plist"];
    userID = [NSString stringWithContentsOfFile:propertyFile encoding: NSUTF8StringEncoding error:NULL ];
    if(userID) {
        NSLog(@"UserID loaded %@",userID);
        NSString *userIdString = @"phoneId=";
        userIdString = [userIdString stringByAppendingString: userID];
        url = [url stringByAppendingString:userIdString];
        first = NO;
        
        //TODO: store userID into post
    }
    else
    {
        //load new User ID into plist
        CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
        [uniqueID writeToFile:propertyFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        //TODO: store userID into post
        CFRelease(uniqueRef);
    }
    if([self.descriptionTextView.text isEqualToString:@""] || [self.itemtitle.text  isEqualToString: @""] || [self.zipCode.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill Required Fields" 
                                                        message:@"Not all required fields were filled"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }else{
        //obtain user's unique ID
        NSString * userID;
        NSArray *directory = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        // get documents path
        NSString *rootD = [directory objectAtIndex:0];
        NSString *propertyFile = [rootD stringByAppendingPathComponent:@"userID.plist"];
        userID = [NSString stringWithContentsOfFile:propertyFile encoding: NSUTF8StringEncoding error:NULL ];
        if(userID) {
            NSLog(@"UserID loaded %@",userID);
            //TODO: store userID into post
        }
        else
        {
            //load new User ID into plist
            CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
            NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
            [uniqueID writeToFile:propertyFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            //TODO: store userID into post
            CFRelease(uniqueRef);
        }
        
        if ([self.descriptionTextView text] != nil){
            NSString *descriptionString = @"description=";
            descriptionString = [descriptionString stringByAppendingString: [self.descriptionTextView text]];
            if (!first){
                descriptionString = [@"&" stringByAppendingString:descriptionString];
            }
            url = [url stringByAppendingString:descriptionString];
            first = NO;
        self.descriptionTextView.text = nil; //reset field
            [self.descriptionTextViewRequired setHidden:NO];
        }
        if ([self.itemtitle text] != nil){
            NSString *nameString = @"title=";
            nameString = [nameString stringByAppendingString: [self.itemtitle text]];
            if (!first){
                nameString = [@"&" stringByAppendingString:nameString];
            }
            url = [url stringByAppendingString:nameString];
            first = NO;
            self.itemtitle.text = nil;
        }
        if ([self.email text] != nil){
            NSString *emailString = @"email=";
            emailString = [emailString stringByAppendingString: [self.email text]];
            if (!first){
                emailString = [@"&" stringByAppendingString:emailString];
            }
            url = [url stringByAppendingString:emailString];
            first = NO;
            self.email.text = nil;
        }
        if ([self.zipCode text] != nil){
            NSString *zipCodeString = @"zipCode=";
            zipCodeString = [zipCodeString stringByAppendingString: [self.zipCode text]];
            if (!first){
                zipCodeString = [@"&" stringByAppendingString:zipCodeString];
            }
            url = [url stringByAppendingString:zipCodeString];
            first = NO;
            self.zipCode.text = nil;
        }
        
        if (gotCoordinate) //we got a coordinate from the map so enter into post
        {
            
            NSString *coordinateString = @"latitude=";
            coordinateString = [coordinateString stringByAppendingString: [NSString stringWithFormat: @"%f&longitude=%f",itemCoordinate.latitude,itemCoordinate.longitude]];
            if (!first){
                coordinateString = [@"&" stringByAppendingString:coordinateString];
            }
            url = [url stringByAppendingString:coordinateString];
            first = NO;
            self.locationLabel.text = @"Location:"; //reset field
            gotCoordinate = false;
        }
        
        if (!first){
            url = [url stringByAppendingString:@"&isLost=false"];
        }else{
            url = [url stringByAppendingString:@"isLost=false"];
        }
        
        NSLog(@"%@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Create" 
                                                        message:@"Your post has been created"
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    }
}

//go to map view to find location of item found
- (IBAction)findLocation:(id)sender {
    if (!foundLocationViewController){
        foundLocationViewController = [[FoundLocationViewController alloc] initWithNibName:@"FoundLocationViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:foundLocationViewController animated:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];   
}

// keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyBoardSize = kbSize;
    CGRect bkgndRect = currentField.superview.frame;
    bkgndRect.size.height = self.view.frame.size.height; 
    [currentField.superview setFrame:bkgndRect];
    
    CGFloat viewCenterY = currentField.center.y;
    CGFloat y = viewCenterY - (self.view.frame.size.height-kbSize.height) / 2.0;
	if (y < 0) {
		y = 0;
	}
    [self.scrollView setContentOffset:CGPointMake(0.0, y) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//methods for text field editing
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentField = textField;
    if (keyBoardSize.width != 0) {
        CGRect bkgndRect = currentField.superview.frame;
        bkgndRect.size.height = self.view.frame.size.height; 
        [currentField.superview setFrame:bkgndRect];
        
        CGFloat viewCenterY = currentField.center.y;
        CGFloat y = viewCenterY - (self.view.frame.size.height-keyBoardSize.height) / 2.0;
        if (y < 0) {
            y = 0;
        }
        [self.scrollView setContentOffset:CGPointMake(0.0, y) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentField = nil;
}

- (IBAction)textFieldEditChanged:(id)sender {
    [((UITextField *)sender) setTextColor:[UIColor blackColor]];
}

//turns keyboard off when user hits return in textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//methods for text View editing
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    currentField= textView;
    [self.descriptionTextViewRequired setHidden:YES];
    if (keyBoardSize.width != 0) {
        CGRect bkgndRect = currentField.superview.frame;
        bkgndRect.size.height = self.view.frame.size.height; 
        [currentField.superview setFrame:bkgndRect];
        
        CGFloat viewCenterY = currentField.center.y;
        CGFloat y = viewCenterY - (self.view.frame.size.height-keyBoardSize.height) / 2.0;
        if (y < 0) {
            y = 0;
        }
        [self.scrollView setContentOffset:CGPointMake(0.0, y) animated:YES];
    }

}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    currentField = nil;
    if ([self.descriptionTextView.text isEqualToString:@""]){
        [self.descriptionTextViewRequired setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
