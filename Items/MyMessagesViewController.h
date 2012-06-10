//
//  MyMessagesViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MessageDetailViewController;
@class SentBoxViewController;
@interface MyMessagesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *xmlDataSoFar;
@property (strong, nonatomic) NSMutableArray *messageList;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) NSMutableArray *titleList;
@property (strong, nonatomic) MessageDetailViewController *messageDetailViewController;
@property (strong, nonatomic) SentBoxViewController *sentBoxViewController;
@end
