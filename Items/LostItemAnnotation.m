//
//  LostItemAnnotation.m
//  Items
//
//  Created by Luis Ramirez on 3/20/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "LostItemAnnotation.h"


@implementation LostItemAnnotation
@synthesize title, subTitle, coordinate, arrayPosition;

- (id)initWithName:(NSString*)name1 subtitle:(NSString *)subTitle1 coordinate:(CLLocationCoordinate2D)coordinate1{
    if(self = [super init]){
        self.title = name1;
        self.subTitle = subTitle1;
        self.coordinate = coordinate1;
    }
    return self;
}



@end
