//
//  Location.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * buildingNumber;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * abbr;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * campus;
@property (nonatomic, retain) NSString * snippet;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;

@end
