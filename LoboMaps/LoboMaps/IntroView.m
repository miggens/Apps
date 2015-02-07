//
//  IntroView.m
//  OneStopApp
//
//  Created by Alfred Sanchez on 11/10/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "IntroView.h"

@interface IntroView ()

@property NSData* imgData;

@end

@implementation IntroView

@synthesize imgData;

- (id)initWithFrame:(CGRect)frame
{
  NSLog(@"INTRO VIEW IWF");
  self = [super initWithFrame:frame];
  
  if (self)
  {
    
  }
  
  return self;
}

- (void)awakeFromNib
{
  
}

- (void)drawRect:(CGRect)rect
{
  
  /*
   * Still need to add image to BG
   */
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGGradientRef backgroundGradient;
  size_t num_locations  = 3;
  CGFloat backgroundGradientLocations[3]  = { 0.0, 0.9, 1.0 };
  CGFloat backgroundGradientColors[12] = {
    (120.0/255.0), (120.0/255.0), (120.0/255.0), 1.0,
    (192.0/255.0), (192.0/255.0), (192.0/255.0), 1.0,
    (255.0/255.0), (0.0/255.0), (0.0/255.0), 1.0,
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
