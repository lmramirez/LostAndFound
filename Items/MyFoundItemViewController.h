//
//  MyFoundItemViewController.h
//  Items
//
//  
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendMessageViewController;
@class ItemOnMapViewController;
@interface MyFoundItemViewController : UIViewController{
    @public
    BOOL hasSendButton; 
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UIButton *sendMessage;
@property (strong, nonatomic) NSString *createdAtText;
@property (strong, nonatomic) NSString *photoId;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *emailText;
@property (strong, nonatomic) NSString *zipcodeText;
@property (strong, nonatomic) NSString *rewardText;
@property (strong, nonatomic) NSString *phoneId;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) SendMessageViewController *sendMessageViewController;
@property (strong, nonatomic) ItemOnMapViewController * itemOnMapViewController;
- (IBAction)sendMessageButton:(id)sender;
- (IBAction)locationView:(id)sender;


@end
