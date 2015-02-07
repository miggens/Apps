//
//  LocationHelper.m
//  AppContest
//
//  Created by Alfred Sanchez on 11/21/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

@synthesize type;
@synthesize title;
@synthesize buildingNumber;
@synthesize abbr;
@synthesize campus;
@synthesize address;
@synthesize latitude;
@synthesize longitude;
@synthesize keywords;
@synthesize desc;

- (void)printLocation
{
  printf("Location:\ntype %s\ntitle %s\nbuildNum %d\nabbr %s\ncampus %s\naddress %s\nlat %lf\nlong %lf\nkw %s\ndescription %s\n\n",[self.type UTF8String], [self.title UTF8String], [self.buildingNumber intValue], [self.abbr UTF8String], [self.campus UTF8String], [self.address UTF8String], [self.latitude doubleValue], [self.longitude doubleValue], [self.keywords UTF8String], [self.desc UTF8String]);
}

@end
