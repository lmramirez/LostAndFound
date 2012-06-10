//
//  MessageDetailViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendMessageViewController;
@interface MessageDetailViewController : UIViewController{
@public
    BOOL showButton;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)replyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) SendMessageViewController *sendMessageViewController;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *dateText;
@property (strong, nonatomic) NSString *toUidString;
@property (strong, nonatomic) NSString *fromUidString;
@property (weak, nonatomic) IBOutlet UIButton *replyUIButton;

@end
