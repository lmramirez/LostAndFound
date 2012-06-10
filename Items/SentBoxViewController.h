//
//  SentBoxViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageDetailViewController;

@interface SentBoxViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *xmlDataSoFar;
@property (strong, nonatomic) NSMutableArray *messageList;;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) MessageDetailViewController *messageDetailViewController;
@end
