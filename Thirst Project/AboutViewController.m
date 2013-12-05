//
//  AboutViewController.m
//  Thirst Project
//
//  Created by Christopher Miller on 4/15/13.
//  Copyright (c) 2013 Thirst Project. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Navbar color for iOS6/7.
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    } else {
        self.navigationController.navigationBar.tintColor = [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
