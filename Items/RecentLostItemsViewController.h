//
//  RecentLostItemsViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import "RecentLostMapViewController.h"


@class RecentLostMapViewController;
@interface RecentLostItemsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recentLostTable;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSString *currentZip;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;
@property (strong, nonatomic) RecentLostMapViewController *recentLostMapViewController;
@end
