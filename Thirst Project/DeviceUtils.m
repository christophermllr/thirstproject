//
//  DeviceUtils.m
//  Thirst Project
//
//  Created by Kevin Kinnebrew on 2/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "DeviceUtils.h"

@implementation DeviceUtils

+ (BOOL)isiOS7OrGreater
{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    return ([[ver objectAtIndex:0] intValue] >= 7);
}

@end
