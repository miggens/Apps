//
//  InfoView.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/10/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "InfoView.h"

@interface InfoView ()

@property (strong, nonatomic) UIButton* dismissButton;
@property (strong, nonatomic) Location* displayInfo;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UITextView* textView;


@end

@implementation InfoView

@synthesize presentingController;


- (id)initWithFrame:(CGRect)frame displayInfo:(Location*) info
{
  self = [super initWithFrame:frame];
  
  if (self)
  {
    NSLog(@"InfoView Frame (%f, %f, %f, %f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    CGRect textViewRect = CGRectMake(0, 10, frame.size.width, frame.size.height/2);
    
    self.layer.cornerRadius = 5.0;
    self.displayInfo = info;
    
    NSString* snip = [info snippet];
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:[self santizedString:snip]];
    
    NSUInteger strlen = [labelText length];
    
    UIColor* textColor = [UIColor colorWithRed:0.2 green:0.1 blue:0.1 alpha:1.0];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    NSShadow* textShadow = [[NSShadow alloc] init];
    [textShadow setShadowBlurRadius:5.0];
    [textShadow setShadowColor:[UIColor grayColor]];
    [textShadow setShadowOffset:CGSizeMake(0, 3)];
    
    [labelText addAttribute:NSFontAttributeName
                      value:font
                      range:NSMakeRange(0, strlen)];
    
    [labelText addAttribute:NSForegroundColorAttributeName
                      value:textColor
                      range:NSMakeRange(0, strlen)];
    
    [labelText addAttribute:NSShadowAttributeName
                      value:textShadow
                      range:NSMakeRange(0, strlen)];
    
    self.textView = [[UITextView alloc] initWithFrame:textViewRect];
    self.textView.attributedText  = labelText;
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.selectable      = NO;
    
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissButton.frame = frame;
    //self.dismissButton.backgroundColor = [UIColor redColor];
    [self.dismissButton addTarget:self
                           action:@selector(dismissView)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.dismissButton];
    [self addSubview:self.textView];
  }
  
  return self;
}

- (NSString*)santizedString:(NSString*) dirtyString
{
  if (dirtyString == nil) return @"NO Snippet";
  NSError* error;
  NSString* breakPattern = @"\\<br\\>";
  NSString* closingBreakPattern = @"\\<br\\/\\>";
  
  NSString* aPattern = @"\\<[^\\>]*\\>";
  
  NSRegularExpression* breakRegex = [NSRegularExpression regularExpressionWithPattern:breakPattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSRegularExpression* tagPattern = [NSRegularExpression regularExpressionWithPattern:aPattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSRange breakRange = NSMakeRange(0, [dirtyString length]);
  
  NSString* tmp = [breakRegex stringByReplacingMatchesInString:dirtyString options:NSMatchingReportProgress range:breakRange withTemplate:@"\n"];
  /*
  NSRange closingBreakRange = NSMakeRange(0, [tmp length]);
  
  return [closingBreakRegex stringByReplacingMatchesInString:tmp
                                                     options:NSMatchingReportProgress
                                                       range: closingBreakRange
                                                withTemplate:@""];
  
  return [tagPattern stringByReplacingMatchesInString:tmp
                                              options:NSMatchingReportProgress
                                                range:NSMakeRange(0, [tmp length])
                                         withTemplate:@""];
   */
  //return tmp;
  
  return [tagPattern stringByReplacingMatchesInString:tmp
                                              options:NSMatchingReportProgress
                                                range:NSMakeRange(0, [tmp length])
                                         withTemplate:@""];
}

- (NSUInteger)countTags:(NSString*)dirtyString
{
  NSUInteger n = 0;
  NSArray* components = [dirtyString componentsSeparatedByString:@" "];
  for (NSString* str in components)
  {
    if ([str compare:@"<br>"] == NSOrderedSame) n++;
  }
  
  return n;
}

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
    (255/255.0), (255/255.0), (255/255.0), 1.0,
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

- (void)dismissView
{
  [self.presentingController dismissViewControllerAnimated:YES completion:^{

  }];
}

@end
