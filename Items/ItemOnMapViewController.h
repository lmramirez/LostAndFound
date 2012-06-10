//
//  ItemOnMapViewController.h
//  Items
//
//  Created by Sophia on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
@interface ItemOnMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationCoordinate2D itemLocation;
-(void) resetLocation; //function to reset location you are viewing
@end
