//
//  LostMenuViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateLostPostViewController;
@class MyLostListViewController;
@interface LostMenuViewController : UIViewController

- (IBAction)createPost:(id)sender;
- (IBAction)myItems:(id)sender;

@property (strong, nonatomic) CreateLostPostViewController *createLostPostViewController;
@property (strong, nonatomic) MyLostListViewController *myLostListViewController;
@end
