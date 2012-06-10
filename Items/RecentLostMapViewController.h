//
//  RecentLostMapViewController.h
//  Items
//
//  Created by Luis Ramirez on 3/19/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XMLReader.h"
#import "LostItemAnnotation.h"
#import "FoundItemViewController.h"

@interface RecentLostMapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *foundItems;
@property (strong, nonatomic) NSString *xmlDataSoFar;

-(BOOL) isRecent:(id)itemDate;
-(void) plotLostItems;
-(IBAction)goToItemDetail:(id)sender;
@end
