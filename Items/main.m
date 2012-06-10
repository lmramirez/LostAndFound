//
//  main.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ECS189AppDelegate.h"

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"oi5xo9YyrH1Q2vqv5FhGLo0y864ALsaAbj6rtPZR" 
                  clientKey:@"2RqvGcouXl3WHvUkdDIJt8x5OXupq9GVSxhku3Ch"];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([ECS189AppDelegate class]));
    }
}
