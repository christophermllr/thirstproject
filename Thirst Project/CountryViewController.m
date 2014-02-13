//
//  WellViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 11/3/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "CountryViewController.h"
#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "AppDelegate.h"
#import "ThirstProjectConfig.h"

@interface CountryViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray *countries;

@end

@implementation CountryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Parse the school data.
    NSError *e = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.countryData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Internet Connection is Required"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return; //TODO send user back to initial view controller?
    }
    
    self.countries = [NSJSONSerialization JSONObjectWithData:appDelegate.countryData
                                                   options:kNilOptions
                                                     error:&e];
    
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
