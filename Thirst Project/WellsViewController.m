//
//  WellsViewController.m
//  Thirst Project
//
//  Created by Krystin Stutesman on 3/7/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "WellsViewController.h"
#import "CountryViewController.h"
#import "Country.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"


@interface WellsViewController ()

@end

@implementation WellsViewController

@synthesize flagImage;
@synthesize countryImage;
@synthesize wellsBuilt;
@synthesize moneyDonated;
@synthesize peopleServed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO Set navBar title
    self.navigationItem.title = @"";
    
	// Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
