//
//  Downloads.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "Downloads.h"


@implementation Downloads

@dynamic bluePhonesNorth;
@dynamic bluePhonesSouth;
@dynamic computerPods;
@dynamic dining;
@dynamic gyms;
@dynamic healthyVending;
@dynamic lactationStation;
@dynamic libraries;
@dynamic mapBuildings;
@dynamic meteredParking;
@dynamic nextSchedule;
@dynamic otherCampuses;
@dynamic placesOfInterest;
@dynamic restrooms;
@dynamic shuttles;
@dynamic walkingRoutes;

- (BOOL)allDownloadsComplete
{
  if (self.mapBuildings == NO) return NO;
  else if (self.bluePhonesNorth == NO) return NO;
  else if (self.bluePhonesSouth == NO) return NO;
  else if (self.computerPods == NO) return NO;
  else if (self.dining == NO) return NO;
  else if (self.gyms == NO) return NO;
  else if (self.healthyVending == NO) return NO;
  else if (self.lactationStation == NO) return NO;
  else if (self.libraries == NO) return NO;
  else if (self.meteredParking == NO) return NO;
  else if (self.otherCampuses == NO) return NO;
  else if (self.restrooms == NO) return NO;
  else if (self.placesOfInterest == NO) return NO;
  else if (self.shuttles == NO) return NO;
  else if (self.walkingRoutes == NO) return NO;
  
  return YES;
}

@end
