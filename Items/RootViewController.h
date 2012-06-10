//
//  RootViewController.h
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class LostMenuViewController;
@class FoundMenuViewController;
@class MyMessagesViewController;
@class RecentLostItemsViewController;
@interface RootViewController : UIViewController
- (IBAction)switchToLostItemMenu:(id)sender;
- (IBAction)switchToFoundItemMenu:(id)sender;
- (IBAction)switchToMyMessages:(id)sender;

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)switchToRecentLostItems:(id)sender;
@property (strong, nonatomic) RecentLostItemsViewController * recentLostItemsViewController;
@property (strong, nonatomic) LostMenuViewController * lostMenuViewController;
@property (strong, nonatomic) FoundMenuViewController * foundMenuViewController;
@property (strong, nonatomic) MyMessagesViewController * myMessagesViewController;
@end
