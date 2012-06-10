//
//  LostMenuViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LostMenuViewController.h"
#import "CreateLostPostViewController.h"
#import "MyLostListViewController.h"

@implementation LostMenuViewController

@synthesize createLostPostViewController;
@synthesize myLostListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Lost Menu";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)createPost:(id)sender {
    if (!createLostPostViewController){
        createLostPostViewController = [[CreateLostPostViewController alloc] initWithNibName:@"CreateLostPostViewController" bundle:nil];
    }
    [self.navigationController pushViewController:createLostPostViewController animated:YES];
}

- (IBAction)myItems:(id)sender {
    if (!myLostListViewController){
        myLostListViewController = [[MyLostListViewController alloc] initWithNibName:@"MyLostListViewController" bundle:nil];
    }
    else [myLostListViewController getItems]; //refresh the list
    
    [self.navigationController pushViewController:myLostListViewController animated:YES];
}
@end
