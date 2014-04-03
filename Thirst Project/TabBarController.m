//
//  TabBarController.m
//  Thirst Project
//
//  Created by Christopher Miller on 4/2/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
