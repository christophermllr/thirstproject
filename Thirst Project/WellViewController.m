//
//  WellViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 11/3/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "WellViewController.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"

@interface WellViewController ()

@end

@implementation WellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
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
