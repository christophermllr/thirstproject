//
//  InfoViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 12/5/13.
//  Edited by Kevin Kinnebrew 2/12/14
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "InfoViewController.h"
#import "DeviceUtils.h"
#import "ThirstProjectConfig.h"

@interface InfoViewController ()
@property (nonatomic, retain) IBOutlet UILabel *version;
@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"Version: %@", version];
    
    // Set Navbar color for iOS6/7.
    if ([DeviceUtils isiOS7OrGreater]) {
        self.navigationController.navigationBar.barTintColor = [ThirstProjectConfig defaultColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.tintColor = [ThirstProjectConfig defaultColor];
    }
}

- (IBAction)done:(id)sender
{
    [self.delegate infoViewControllerDidClose:self];
}

@end
