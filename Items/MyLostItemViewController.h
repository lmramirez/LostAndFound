//
//  MyLostItemViewController.h
//  Items
//
//  
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SimilarFoundPostsViewController;
@class ItemOnMapViewController;
@interface MyLostItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) NSString *createdAtText;
@property (strong, nonatomic) NSString *photoId;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *emailText;
@property (strong, nonatomic) NSString *zipcodeText;
@property (strong, nonatomic) NSString *rewardText;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) SimilarFoundPostsViewController *similarFoundPostsViewController;
@property (strong, nonatomic) ItemOnMapViewController * itemOnMapViewController;
- (IBAction)similarFoundPostsButton:(id)sender;
- (IBAction)locationMap:(id)sender;


@end
