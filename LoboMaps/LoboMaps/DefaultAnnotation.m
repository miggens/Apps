//
//  DefaultAnnotation.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/7/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "DefaultAnnotation.h"

@implementation DefaultAnnotation

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)paramTitle
                            subTitle:(NSString *)paramSubTitle
{
  self = [super init];
  
  if (self)
  {
    _coordinate = paramCoordinates;
    _title      = paramTitle;
    _subtitle   = paramSubTitle;
    
  }
  
  return self;
}

@end
