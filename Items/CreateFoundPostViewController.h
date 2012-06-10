//
//  CreateFoundPostViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FoundLocationViewController;
@interface CreateFoundPostViewController : UIViewController <UITextFieldDelegate, UITextFieldDelegate>{
    CGSize keyBoardSize;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *itemtitle;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) UIView * currentField; //point to view currently editing
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextViewRequired;
@property (strong, nonatomic) FoundLocationViewController *foundLocationViewController;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property CLLocationCoordinate2D itemCoordinate;
@property BOOL gotCoordinate;

- (IBAction)makePost:(id)sender;
- (IBAction)findLocation:(id)sender;
- (void)registerForKeyboardNotifications;
- (void) keyboardWasShown:(NSNotification*)aNotification;
- (void) keyboardWillBeHidden:(NSNotification*)aNotification;
- (BOOL) textFieldShouldReturn:(UITextField*)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (IBAction)textFieldEditChanged:(id)sender;

@end
