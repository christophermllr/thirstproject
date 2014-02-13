//
//  Country.h
//  Thirst Project
//
//  Created by Christopher Miller on 2/12/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *imageFilename;
@property (strong, nonatomic) NSNumber *wellCount;
@property (strong, nonatomic) NSNumber *peopleServed;
@property (strong, nonatomic) NSNumber *dollarsDonated;

@end