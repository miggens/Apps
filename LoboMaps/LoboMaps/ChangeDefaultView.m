//
//  ChangeDefaultView.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/10/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "ChangeDefaultView.h"

@interface ChangeDefaultView ()

@property (strong, nonatomic) NSMutableDictionary* sectionData;
@property (strong, nonatomic) NSMutableArray* tmpSectionTitles;
@property (strong, nonatomic) UITableView* typesTableView;
@property (strong, nonatomic) UITableView* titlesTableView;
@property (strong, nonatomic) NSArray* sectionTitles;
@property (strong, nonatomic) NSArray* selectedLocations;
@property (strong, nonatomic) NSArray* selectedLocationTitles;
@property (strong, nonatomic) NSString* selectedCategory;

@end

@implementation ChangeDefaultView

@synthesize types;
@synthesize titles;
@synthesize locations;

- (id)initWithFrame:(CGRect)frame newLocation:(NSString*)newLocation
{
  self = [super initWithFrame:frame];
  
  if (self)
  {
    NSLog(@"NEW DEFAULT LOCATION: %@", newLocation);
    
    UIButton* dismiss = [UIButton buttonWithType:UIButtonTypeCustom];
    
    dismiss.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [dismiss addTarget:self
                action:@selector(dismissView)
      forControlEvents:UIControlEventTouchUpInside];
    
    self.typesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-30)
                                                       style:UITableViewStylePlain];
    self.typesTableView.backgroundColor = [UIColor clearColor];
    self.typesTableView.dataSource = self;
    self.typesTableView.delegate   = self;
    
    self.titlesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-30)
                                                        style:UITableViewStylePlain];
    self.titlesTableView.backgroundColor = [UIColor clearColor];
    self.titlesTableView.dataSource = self;
    self.titlesTableView.delegate   = self;

    dismiss.frame = CGRectMake(0,
                               0,
                               frame.size.width,
                               frame.size.height);
    
    [self addSubview: dismiss];
    [self addSubview:self.typesTableView];
  }
  
  return self;
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
    (255/255.0), (0/255.0), (0/255.0), 1.0,
  };
  
  backgroundGradient = CGGradientCreateWithColorComponents(colorSpace,
                                                           backgroundGradientColors,
                                                           backgroundGradientLocations,
                                                           num_locations);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  
  
  CGContextSetBlendMode(ctx, kCGBlendModeCopy);
  CGContextSetAllowsAntialiasing(ctx, true);
  
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
    NSLog(@"DISMISSED FROM ANOTHER VIEW");
    //[self.navController popViewControllerAnimated:YES];
  }];
}

- (void)createSectionTitles
{
  self.tmpSectionTitles = [NSMutableArray array];
  
  for (Location* loc in self.locations)
  {
    NSString* title = loc.title;
    
    if ([self.selectedCategory compare:@"Lactation Stations"] == NSOrderedSame)
    {
      title = [loc.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    unichar firstCharacter = [title characterAtIndex:0];
    NSString* sectionTitle = [[NSString stringWithCharacters:&firstCharacter length:1] uppercaseString];
    
    if (![self.tmpSectionTitles containsObject:sectionTitle])
    {
      [self.tmpSectionTitles addObject:sectionTitle];
    }
  }
}

- (void)createSectionData
{
  self.sectionData   = [NSMutableDictionary dictionary];
  
  for (Location* loc in self.locations)
  {
    NSString* title = loc.title;
    
    if ([self.selectedCategory compare:@"Lactation Stations"] == NSOrderedSame)
    {
      title = [loc.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    unichar firstCharacter = [title characterAtIndex:0];
    NSString* sectionTitle = [[NSString stringWithCharacters:&firstCharacter length:1] uppercaseString];
    
    NSArray* keys = [self.sectionData allKeys];
    
    if (![keys containsObject:sectionTitle])
    {
      [self.sectionData setObject:[NSMutableArray array]
                           forKey:sectionTitle];
    }
  }
  
  for (Location* loc in self.locations)
  {
    NSString* title = loc.title;
    
    if ([self.selectedCategory compare:@"Lactation Stations"] == NSOrderedSame)
    {
      title = [loc.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    unichar firstCharacter = [title characterAtIndex:0];
    
    printf("FIRST CHARACTER |%c|\n", firstCharacter);
    NSString* sectionTitle = [[NSString stringWithCharacters:&firstCharacter length:1] uppercaseString];
    
    NSMutableArray* tTitles = [self.sectionData objectForKey:sectionTitle];
    [tTitles addObject:title];
  }
}

#pragma mark TableView View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.typesTableView)
  {
    return 1;
  }
  else if (tableView == self.titlesTableView)
  {
    return [self.sectionTitles count];
  }
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.typesTableView)
  {
    return [self.types count];
  }
  else if (tableView == self.titlesTableView)
  {
    NSString* key = [self.sectionTitles objectAtIndex: section];
    NSMutableArray* tTitles = [self.sectionData objectForKey:key];
    return [tTitles count];
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *simpleTableIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (tableView == self.typesTableView)
  {
  
    if (cell == nil)
    {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:simpleTableIdentifier];
    }
  

    NSString* text = [self.types objectAtIndex:indexPath.row];
    NSUInteger strlen = [text length];
  
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:text];
  
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
  
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.attributedText = labelText;
  //cell.textLabel.text = text;
    [cell.textLabel sizeToFit];
  }
  else if (tableView == self.titlesTableView)
  {
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString* key = [self.sectionTitles objectAtIndex:indexPath.section];
    NSMutableArray* tTitles = [self.sectionData objectForKey:key];
    
    //NSString* text = [[self.locationsList objectAtIndex:indexPath.row]title];
    NSString* text = [tTitles objectAtIndex:indexPath.row];
    //NSLog(@"TEXT %@", text);
    NSUInteger strlen = [text length];
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc] initWithString:text];
    
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.attributedText = labelText;
  }

  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == self.typesTableView)
  {
    self.selectedCategory = [self.titles objectForKey:[self.types objectAtIndex:indexPath.row]];

    NSPredicate* selectedPredicate = [NSPredicate predicateWithFormat:@"type == %@", self.selectedCategory];
    self.selectedLocations = [self.locations filteredArrayUsingPredicate:selectedPredicate];
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    for (Location* loc in self.selectedLocations)
    {
      [tmpArray addObject:loc.title];
    }
    
    [self createSectionTitles];
    [self createSectionData];
    
    self.selectedLocationTitles = [NSArray arrayWithArray:tmpArray];
    
    [self.typesTableView removeFromSuperview];
    [self addSubview:self.titlesTableView];
  }
  
  
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self.sectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  
  return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  return [self.sectionTitles indexOfObject:title];
}

@end
