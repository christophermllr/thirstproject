//
//  CountryBuilder.m
//  Thirst Project
//
//  Created by Christopher Miller on 2/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import "CountryBuilder.h"
#import "Country.h"

@implementation CountryBuilder

+ (NSArray *)countriesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    
    for (NSDictionary *countryDic in parsedObject) {
        Country *country = [[Country alloc] init];
        
        for (NSString *key in countryDic) {
            if ([country respondsToSelector:NSSelectorFromString(key)]) {
                [country setValue:[countryDic valueForKey:key] forKey:key];
            }
        }
        
        [countries addObject:country];
    }
    
    return countries;
}

@end