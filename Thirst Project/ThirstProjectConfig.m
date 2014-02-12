//
//  ThirstProjectConfig.m
//  Thirst Project
//
//  Created by Kevin Kinnebrew on 2/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "ThirstProjectConfig.h"
#import "AppDelegate.h"

@implementation ThirstProjectConfig

+ (UIColor *)defaultColor
{
    return [(AppDelegate *)[UIApplication sharedApplication].delegate TPColor];
}
@end
