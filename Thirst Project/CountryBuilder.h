//
//  CountryBuilder.h
//  Thirst Project
//
//  Created by Christopher Miller on 2/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryBuilder : NSObject

+ (NSArray *)countriesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end