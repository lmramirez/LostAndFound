//
//  CreateLostPostViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
@class FindLocationViewController;
@interface CreateLostPostViewController : UIViewController< UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate> {
    CGSize keyBoardSize;
}

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property CLLocationCoordinate2D itemCoordinate;
@property BOOL gotCoordinate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UILabel *descriptionRequiredText;

@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *reward;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *zipCode;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView * currentField; //point view was originally
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) FindLocationViewController *findLocationViewController;
- (IBAction)getLocation:(id)sender;
- (IBAction)getPhoto:(id)sender;
- (IBAction)makePost:(id)sender;
- (void)registerForKeyboardNotifications;
- (void) keyboardWasShown:(NSNotification*)aNotification;
- (void) keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
@end
