//
//  WellViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 11/3/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "CountryViewController.h"
#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "AppDelegate.h"
#import "ThirstProjectConfig.h"
#import "Reachability.h"
#import "Country.h"

@interface CountryViewController ()

@property (nonatomic, strong) NSArray *countries;

@end

@implementation CountryViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    /* NSMutableArray *countries = [NSMutableArray array];
    for (NSDictionary //not sure what goes here)
    {
        [countries addObject:[dictionary valueForKey:@"countryName"]];
    }
    NSLog(@"%@",countries);
    */
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_countries count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO incomplete
    
}

#pragma mark - InfoViewControllerDelegate

- (void)infoViewControllerDidClose:(InfoViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewInfo"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        InfoViewController *infoViewController = [navigationController viewControllers][0];
        infoViewController.delegate = self;
    }
}

@end
