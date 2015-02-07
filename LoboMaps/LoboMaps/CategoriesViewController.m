//
//  CategoriesViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "CategoriesViewController.h"

@interface CategoriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* types;
@property NSDictionary* titles;

@end

@implementation CategoriesViewController

@synthesize locations; 

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  
  if(self)
  {

  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.types = [NSArray arrayWithObjects:@"Buildings", @"Computer Pods", @"Dining", @"Gyms", @"Healthy Vending", @"Lactation Stations", @"Libraries", @"Metered Parking", @"Other Campuses", @"Places of Interest", @"Restrooms", @"Shuttles", @"Walking Routes", nil];
  
  
  self.titles = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"mapBuildings", @"Buildings",
                 @"computerPods", @"Computer Pods",
                 @"dining", @"Dining",
                 @"gyms", @"Gyms",
                 @"healthyVending", @"Healthy Vending",
                 @"lactationStation", @"Lactation Stations",
                 @"libraries", @"Libraries",
                 @"meteredParking", @"Metered Parking",
                 @"otherCampuses", @"Other Campuses",
                 @"placesOfInterest", @"Places of Interest",
                 @"restrooms", @"Restrooms",
                 @"shuttles", @"Shuttles",
                 @"walkingRoutes", @"Walking Routes",nil];
  
  //NSLog(@"%@", self.locations);
  
  if ([[self.locations firstObject] class] != [Location class])
  {
    self.locations = nil;
    
    NSError* error;
    NSFetchRequest* downloadsFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* downloadsEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [downloadsFetch setEntity:downloadsEntity];
    self.locations = [self.managedObjectContext executeFetchRequest:downloadsFetch error:&error];
    if (error)
    {
      NSLog(@"ERROR: Could not fetch downloads %@", [error localizedDescription]);
    }
  }
}

-(void)viewWillAppear:(BOOL)animated
{
  self.title = @"What Are You Looking For?";
  self.navigationController.navigationBarHidden = NO;
  [self.navigationItem setHidesBackButton:YES];
  
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.dataSource = self;
  self.tableView.delegate   = self;
  
  UINavigationBar* navBar = self.navigationController.navigationBar;
  
  navBar.barStyle  = UIBarStyleBlack;
  navBar.tintColor = [UIColor redColor];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *simpleTableIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
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
  [cell.textLabel sizeToFit];
  
  return cell;
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString* selectedCategory = [self.titles objectForKey:[self.types objectAtIndex:indexPath.row]];
  
  NSPredicate* selectedPredicate = [NSPredicate predicateWithFormat:@"type == %@", selectedCategory];
  NSPredicate* phonesPredicate = [NSPredicate predicateWithFormat:@"type == %@ || type == %@", @"bluePhonesNorth", @"bluePhonesSouth"];
  NSArray* selectedLocations = [self.locations filteredArrayUsingPredicate:selectedPredicate];
  NSArray* phoneLocations = [self.locations filteredArrayUsingPredicate:phonesPredicate];
  
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  LocationListViewController* listView = [storyboard instantiateViewControllerWithIdentifier:@"LocationList"];
  [listView setLocationsList:selectedLocations];
  [listView setPhoneList:phoneLocations];
  [listView setDisplayTitle:[self.types objectAtIndex:indexPath.row]];
  [listView setCDTypes:self.types];
  [listView setCDTitles:self.titles];
  [listView setCDLocations:self.locations];
  
  
  [listView setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  [listView setManagedObjectContext:self.managedObjectContext];
  [listView setManagedObjectModel:self.managedObjectModel];
  
  [self.navigationController pushViewController:listView animated:YES];
}

@end
