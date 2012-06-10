//
// MyLostListViewController.h
//  Items
//
//  
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLostListViewController.h"

@class MyLostItemViewController;
@interface MyLostListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) MyLostItemViewController *childController;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;
-(void) getItems;
@end
