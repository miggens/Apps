//
//  DisplayView.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/5/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "DisplayView.h"

@implementation DisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGGradientRef backgroundGradient;
  size_t num_locations  = 3;
  CGFloat backgroundGradientLocations[3]  = { 0.0, 0.9, 1.0 };
  CGFloat backgroundGradientColors[12] = {
    (120.0/255.0), (120.0/255.0), (120.0/255.0), 1.0,
    (192.0/255.0), (192.0/255.0), (192.0/255.0), 1.0,
    (0.0/255.0), (0.0/255.0), (0.0/255.0), 1.0,
  };
  backgroundGradient = CGGradientCreateWithColorComponents(colorSpace,
                                                           backgroundGradientColors,
                                                           backgroundGradientLocations,
                                                           num_locations);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextSetBlendMode(ctx, kCGBlendModeCopy);
  CGContextSetAllowsAntialiasing(ctx, true);
  CGContextTranslateCTM(ctx, 0.0, rect.size.height);
  CGContextScaleCTM(ctx, 1.0, -1.0);
  
  //draw background
  CGPoint myStartPoint, myEndPoint;
  myStartPoint.x = 0.0;
  myStartPoint.y = 0.0;
  myEndPoint.x   = 0.0;
  myEndPoint.y   = rect.size.height;
  CGContextDrawLinearGradient (ctx, backgroundGradient, myStartPoint, myEndPoint, 0);
}




@end
