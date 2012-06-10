//
//  FoundMenuViewController.m
//  Items
//
//  Created by Armen Khodaverdian on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoundMenuViewController.h"
#import "CreateFoundPostViewController.h"
#import "SearchLostPostViewController.h"
#import "MyFoundListViewController.h"
#import "RecentLostItemsViewController.h"

@implementation FoundMenuViewController

@synthesize createFoundPostViewController;
@synthesize searchLostPostViewController;
@synthesize myFoundListViewController;
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
    self.title = @"Found Menu";
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

- (IBAction)search:(id)sender {
    if (!searchLostPostViewController){
        searchLostPostViewController = [[SearchLostPostViewController alloc] initWithNibName:@"SearchLostPostViewController" bundle:nil];
    }
    [self.navigationController pushViewController:searchLostPostViewController animated:YES];
}

- (IBAction)createPost:(id)sender {
    if (!createFoundPostViewController){
        createFoundPostViewController = [[CreateFoundPostViewController alloc] initWithNibName:@"CreateFoundPostViewController" bundle:nil];
    }
    [self.navigationController pushViewController:createFoundPostViewController animated:YES];
}

- (IBAction)myItems:(id)sender {
    if (!myFoundListViewController){
        myFoundListViewController = [[MyFoundListViewController alloc] initWithNibName:@"MyFoundListViewController" bundle:nil];
    }
    [self.navigationController pushViewController:myFoundListViewController animated:YES];
}



@end
