//
//  FoundMenuViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreateFoundPostViewController;
@class SearchLostPostViewController;
@class MyFoundListViewController;
@class RecentLostItemsViewController;
@interface FoundMenuViewController : UIViewController
- (IBAction)search:(id)sender;

- (IBAction)createPost:(id)sender;
- (IBAction)myItems:(id)sender;


@property (strong, nonatomic) CreateFoundPostViewController *createFoundPostViewController;
@property (strong, nonatomic) SearchLostPostViewController *searchLostPostViewController;
@property (strong, nonatomic) MyFoundListViewController *myFoundListViewController;
@end
