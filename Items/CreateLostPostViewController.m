//
//  CreateLostPostViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//    

#import "CreateLostPostViewController.h"
#import "FindLocationViewController.h"
#import <Parse/Parse.h>
@implementation CreateLostPostViewController
@synthesize descriptionTextView;
@synthesize backgroundImage;
@synthesize picker;
@synthesize descriptionRequiredText;
@synthesize mapButton;
@synthesize locationLabel;
@synthesize imageView;
@synthesize choosePhotoButton;
@synthesize reward;
@synthesize name;
@synthesize email;
@synthesize zipCode;
@synthesize scrollView;
@synthesize currentField;
@synthesize findLocationViewController;
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
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    keyBoardSize = CGSizeMake(0, 0);
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height);
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)]; 
    self.backgroundImage.frame = CGRectMake(-12,-37, 343, 1110);
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:2.0];
    [[self.descriptionTextView layer] setCornerRadius:10];  
    [self.descriptionTextView setEnablesReturnKeyAutomatically:YES];
    
    //initialize location
    gotCoordinate = false;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{

    [self setChoosePhotoButton:nil];
    [self setImageView:nil];
    [self setReward:nil];
    [self setName:nil];
    [self setEmail:nil];
    [self setZipCode:nil];
    [self setScrollView:nil];
    [self setBackgroundImage:nil];
    [self setDescriptionTextView:nil];
    [self setDescriptionRequiredText:nil];
    [self setMapButton:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getPhoto:(id)sender {
    if((UIButton *) sender == choosePhotoButton) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    [self presentModalViewController:picker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picked didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picked dismissModalViewControllerAnimated:YES];
    UIImage *I = [info objectForKey:UIImagePickerControllerEditedImage];
    [imageView setImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    
}

- (IBAction)makePost:(id)sender {
    NSString *url = @"http://cancer.cs.ucdavis.edu:3050/database/create?";
    BOOL first = YES;
    if([self.descriptionTextView.text isEqualToString:@""] || [self.name.text  isEqualToString: @""] || [self.zipCode.text  isEqualToString: @""]){
        
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
            NSString *userIdString = @"phoneId=";
            userIdString = [userIdString stringByAppendingString: userID];
            url = [url stringByAppendingString:userIdString];
            first = NO;

        }
        else
        {
            //load new User ID into plist
            CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
            NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
            [uniqueID writeToFile:propertyFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
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
            [self.descriptionRequiredText setHidden:NO];
        }
        if ([self.name text] != nil){
            NSString *nameString = @"title=";
            nameString = [nameString stringByAppendingString: [self.name text]];
            if (!first){
                nameString = [@"&" stringByAppendingString:nameString];
            }
            url = [url stringByAppendingString:nameString];
            first = NO;
            self.name.text = nil; //reset field
        }
        if ([self.email text] != nil){
            NSString *emailString = @"email=";
            emailString = [emailString stringByAppendingString: [self.email text]];
            if (!first){
                emailString = [@"&" stringByAppendingString:emailString];
            }
            url = [url stringByAppendingString:emailString];
            first = NO;
            self.email.text = nil; //reset field
        }
        if ([self.reward text] != nil){
            NSString *rewardString = @"reward=";
            rewardString = [rewardString stringByAppendingString: [self.reward text]];
            if (!first){
                rewardString = [@"&" stringByAppendingString:rewardString];
            }
            url = [url stringByAppendingString:rewardString];
            first = NO;
            self.reward.text = nil; //reset field
        }
        if ([self.zipCode text] != nil){
            NSString *zipCodeString = @"zip=";
            zipCodeString = [zipCodeString stringByAppendingString: [self.zipCode text]];
            if (!first){
                zipCodeString = [@"&" stringByAppendingString:zipCodeString];
            }
            url = [url stringByAppendingString:zipCodeString];
            first = NO;
            self.zipCode.text = nil; //reset field
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
        /**
         add unique id for the image using this reference work:
         http://stackoverflow.com/questions/1110278/iphone-sdk-getting-device-id-or-mac-address
         **/
        if (imageView.image != nil){
            
            CFUUIDRef uniqueRef = CFUUIDCreate(kCFAllocatorDefault);
            NSString *uniqueID = (__bridge NSString *)CFUUIDCreateString(NULL,uniqueRef);
            NSLog(@"New UID= %@.\n",uniqueID);
            //store image in Parse
            NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
            [imageFile save];
            //Referenced from Parse :https://www.parse.com/tutorials/get-started-with-ios
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:uniqueID forKey:@"imageName"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto save];
            NSString *photoIdString = @"photoId=";
            photoIdString = [photoIdString stringByAppendingString:uniqueID];
            if (!first){
                photoIdString = [@"&" stringByAppendingString:photoIdString];
            }
            url = [url stringByAppendingString: [@"&" stringByAppendingString:photoIdString]];
            first = NO;
            
            imageView.image = nil;
            CFRelease(uniqueRef);
        }
        
        if (!first){
            url = [url stringByAppendingString:@"&isLost=true"];
        }else{
            url = [url stringByAppendingString:@"isLost=true"];
        }
        
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

//turns keyboard off when user hits return in textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//methods for text View editing

// resizing and scrolling methods adopted from this reference:
//http://iphoneincubator.com/blog/windows-views/how-to-create-a-data-entry-screen

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    currentField= textView;
    [self.descriptionRequiredText setHidden:YES];
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
        [self.descriptionRequiredText setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



- (IBAction)getLocation:(id)sender {
    if (!findLocationViewController){
        findLocationViewController = [[FindLocationViewController alloc] initWithNibName:@"FindLocationViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:findLocationViewController animated:YES];
    
}
@end
