//
//  FoundItemViewController.h
//  Items
//
//  Created by Luis Ramirez on 3/3/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendMessageViewController;
@class ItemOnMapViewController;
@interface FoundItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

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
- (IBAction)locationMap:(id)sender;

@end
