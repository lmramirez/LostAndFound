//
//  LostItemAnnotation.h
//  Items
//
//  Created by Luis Ramirez on 3/20/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "RecentLostMapViewController.h"

@interface LostItemAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSInteger arrayPosition;

- (id)initWithName:(NSString*)name subtitle:(NSString *)subTitle coordinate:(CLLocationCoordinate2D)coordinate;
@end
