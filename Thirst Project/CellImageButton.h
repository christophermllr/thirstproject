//
//  CellImageButton.h
//  Thirst Project
//
//  Created by Christopher Miller on 2/13/14.
//  Copyright (c) 2014 Thirst Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface CellImageButton : UIButton {
    Country* countryData;
}

@property (nonatomic, readwrite, retain) Country* countryData;

@end