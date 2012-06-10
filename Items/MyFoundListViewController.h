//
//  MyFoundListViewController.h
//  Items
//
//  Created by Sophia.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFoundListViewController.h"

@interface MyFoundListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;

@end
