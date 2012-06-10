//
//  SearchLostPostViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundItemViewController.h"

@interface SearchLostPostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchButton:(id)sender;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;
@end
