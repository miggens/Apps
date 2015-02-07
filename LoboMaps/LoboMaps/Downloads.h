//
//  Downloads.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Downloads : NSManagedObject

@property (nonatomic, retain) NSNumber * bluePhonesNorth;
@property (nonatomic, retain) NSNumber * bluePhonesSouth;
@property (nonatomic, retain) NSNumber * computerPods;
@property (nonatomic, retain) NSNumber * dining;
@property (nonatomic, retain) NSNumber * gyms;
@property (nonatomic, retain) NSNumber * healthyVending;
@property (nonatomic, retain) NSNumber * lactationStation;
@property (nonatomic, retain) NSNumber * libraries;
@property (nonatomic, retain) NSNumber * mapBuildings;
@property (nonatomic, retain) NSNumber * meteredParking;
@property (nonatomic, retain) NSNumber * nextSchedule;
@property (nonatomic, retain) NSNumber * otherCampuses;
@property (nonatomic, retain) NSNumber * placesOfInterest;
@property (nonatomic, retain) NSNumber * restrooms;
@property (nonatomic, retain) NSNumber * shuttles;
@property (nonatomic, retain) NSNumber * walkingRoutes;

- (BOOL)allDownloadsComplete;

@end
