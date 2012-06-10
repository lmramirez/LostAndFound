//
//  SimilarFoundPostsViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyFoundItemViewController;
@interface SimilarFoundPostsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) MyFoundItemViewController *childController;

@end
