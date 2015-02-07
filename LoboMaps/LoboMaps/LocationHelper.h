//
//  LocationHelper.h
//  AppContest
//
//  Created by Alfred Sanchez on 11/21/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * buildingNumber;
@property (nonatomic, strong) NSString * abbr;
@property (nonatomic, strong) NSString * campus;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * desc;

- (void)printLocation;

@end
