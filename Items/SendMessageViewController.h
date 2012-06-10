//
//  SendMessageViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageViewController : UIViewController<UITextFieldDelegate, UITextFieldDelegate>{
    BOOL isFromMessage;
}
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *toUid;
@property (strong, nonatomic) NSString *postId;

@end
