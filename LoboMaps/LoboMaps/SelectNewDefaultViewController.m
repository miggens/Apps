//
//  SelectNewDefaultViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 1/9/15.
//  Copyright (c) 2015 Alfred Sanchez. All rights reserved.
//

#import "SelectNewDefaultViewController.h"
#import "MapViewController.h"
#import "Location.h"

@interface SelectNewDefaultViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* sectionTitles;
@property (strong, nonatomic) NSMutableArray* tmpSectionTitles;
@property (strong, nonatomic) NSMutableDictionary* sectionData;
@property (strong, nonatomic) UITextField* nickname;
@property (strong, nonatomic) NSString* LocationType;


@end

@implementation SelectNewDefaultViewController

@synthesize locations;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel; 

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self createSectionTitles];
  [self createSectionData];
  
  self.sectionTitles = [self.tmpSectionTitles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
  {
    return [obj1 compare:obj2 options:NSNumericSearch];
  }];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.title = @"Select New Location";
  
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSectionTitles
{
  self.tmpSectionTitles = [NSMutableArray array];
  
  for (Location* loc in self.locations)
  {
    NSString* title   = loc.title;
    self.LocationType = loc.type;
    
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
  
  for (Location* loc in self.locations)
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
  
  for (Location* loc in self.locations)
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
  for (Location* l in self.locations)
  {
    NSString* title = l.title;
    if ([self.LocationType compare:@"lactationStation"] == NSOrderedSame)
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
  
  UIColor* textColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.1 alpha:1.0];
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
  [cell.textLabel sizeToFit];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Location* loc = [self getLocationForIndexPath:indexPath];
  
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"New Default Location"
                                                                 message:[NSString stringWithFormat:@"Select %@ for new default location?\n\nAdd nickname", loc.title]
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  {
    NSError* fetchError;
    NSError* error;
    NSFetchRequest* defaultLocationFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"DefaultLocation" inManagedObjectContext:self.managedObjectContext];
    [defaultLocationFetch setEntity:description];
    
    NSArray* fetchArray = [self.managedObjectContext executeFetchRequest:defaultLocationFetch
                                                                   error:&fetchError];
    DefaultLocation* defaultLocation = [fetchArray firstObject];
    
    
    defaultLocation.title     = loc.title;
    defaultLocation.nickname  = self.nickname.text;
    defaultLocation.latitude  = loc.latitude;
    defaultLocation.longitude = loc.longitude;
    
    if (![self.managedObjectContext save:&error])
    {
      NSLog(@"ERROR: Could not save | %@", [error localizedDescription]);
    }
    
    DefaultAnnotation* defaultAnnotation = [[DefaultAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake([defaultLocation.latitude floatValue], [defaultLocation.longitude floatValue])
                                                                                    title:defaultLocation.title
                                                                                 subTitle:defaultLocation.nickname];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    NSArray* vcs = [self.navigationController viewControllers];
    MapViewController* map = [vcs objectAtIndex:3];
    
    [map resetDefaultLocation:defaultAnnotation];
    
    [self.navigationController popToViewController:map animated:YES];
    
  }];
  
  UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
  {
    NSLog(@"Cancel Pressed");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
  }];
  
  
  [alert addAction:okAction];
  [alert addAction:dismiss];
  
  [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
  {
    self.nickname = textField;
    textField.placeholder = @"nickname";
    textField.borderStyle = UITextBorderStyleRoundedRect;

  }];
  
  
  [self presentViewController:alert animated:YES completion:^{
    
  }];
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
