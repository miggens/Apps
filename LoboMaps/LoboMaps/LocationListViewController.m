//
//  LocationListViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/5/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "LocationListViewController.h"

@interface LocationListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* sectionTitles;
@property (strong, nonatomic) NSMutableArray* tmpSectionTitles;
@property (strong, nonatomic) NSMutableDictionary* sectionData;

@end

@implementation LocationListViewController

@synthesize displayTitle; 
@synthesize locationsList;
@synthesize phoneList;
@synthesize CDTypes;
@synthesize CDTitles;
@synthesize CDLocations;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  [self createSectionTitles];
  [self createSectionData];
  self.title = self.displayTitle;

  
  self.tableView.dataSource = self;
  self.tableView.delegate   = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  
  self.sectionTitles = [self.tmpSectionTitles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
  {
    return [obj1 compare:obj2 options:NSNumericSearch];
  }];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  UINavigationBar* navBar = self.navigationController.navigationBar;
  
  navBar.barStyle  = UIBarStyleBlack;
  navBar.tintColor = [UIColor redColor];

  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSectionTitles
{
  self.tmpSectionTitles = [NSMutableArray array];
  
  for (Location* loc in self.locationsList)
  {
    NSString* title = loc.title;
    
    if ([self.title compare:@"Lactation Stations"] == NSOrderedSame)
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
  
  for (Location* loc in self.locationsList)
  {
    NSString* title = loc.title;
    
    if ([self.title compare:@"Lactation Stations"] == NSOrderedSame)
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
  
  for (Location* loc in self.locationsList)
  {
    NSString* title = loc.title;
    
    if ([self.title compare:@"Lactation Stations"] == NSOrderedSame)
    {
      title = [loc.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    unichar firstCharacter = [title characterAtIndex:0];
    NSString* sectionTitle = [[NSString stringWithCharacters:&firstCharacter length:1] uppercaseString];
    
    NSMutableArray* titles = [self.sectionData objectForKey:sectionTitle];
    [titles addObject:title];
  }
}

- (Location*)getLocationForIndexPath:(NSIndexPath*)indexPath
{
  Location* location = nil;
  NSString* key = [self.sectionTitles objectAtIndex:indexPath.section];
  
  NSMutableArray* arr = [self.sectionData objectForKey:key];
  NSString* selected = [arr objectAtIndex:indexPath.row];
  for (Location* l in self.locationsList)
  {
    NSString* title = l.title;
    if ([self.title compare:@"Lactation Stations"] == NSOrderedSame)
    {
      title = [l.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    if ([selected compare:[title stringByReplacingOccurrencesOfString:@"Lactation Stations: " withString:@""]] == NSOrderedSame)
    {
      return l;
    }
  }
  
  return location;
}

#pragma mark Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSString* key = [self.sectionTitles objectAtIndex: section];
  NSMutableArray* titles = [self.sectionData objectForKey:key];
  
  return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *simpleTableIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:simpleTableIdentifier];
  }
  
  NSString* key = [self.sectionTitles objectAtIndex:indexPath.section];
  NSMutableArray* titles = [self.sectionData objectForKey:key];
  
  NSString* text = [titles objectAtIndex:indexPath.row];
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
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  Location* selectedLocation = [self getLocationForIndexPath:indexPath];
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  MapViewController* mapView = [storyboard instantiateViewControllerWithIdentifier:@"MapView"];
  [mapView setSelectedLocation:selectedLocation];
  [mapView setPhones:self.phoneList];
  [mapView setLocationsList:self.locationsList];
  [mapView setCDTypes:self.CDTypes];
  [mapView setCDTitles:self.CDTitles];
  [mapView setCDLocations:self.CDLocations];
  

  
  [mapView setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  [mapView setManagedObjectContext:self.managedObjectContext];
  [mapView setManagedObjectModel:self.managedObjectModel];
  
  [self.navigationController pushViewController:mapView animated:YES];
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
