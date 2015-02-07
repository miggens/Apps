//
//  ChangeDefaultLocationViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 1/9/15.
//  Copyright (c) 2015 Alfred Sanchez. All rights reserved.
//

#import "ChangeDefaultLocationViewController.h"
#import "SelectNewDefaultViewController.h"

@interface ChangeDefaultLocationViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* types;
@property NSDictionary* titles;

@end

@implementation ChangeDefaultLocationViewController


@synthesize CDLocations;
@synthesize CDTitles;
@synthesize CDTypes;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
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
  
  //NSLog(@"CDTitles:   %@", self.CDTitles);
  //NSLog(@"CDTypes:    %@", self.CDTypes);
  //NSLog(@"CDLocations %@", self.CDLocations);
}

-(void)viewWillAppear:(BOOL)animated
{
  self.title = @"Changing Default";
  
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.dataSource = self;
  self.tableView.delegate   = self;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.types count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
  NSString* selectedCategory = [self.titles objectForKey:[self.types objectAtIndex:indexPath.row]];
  NSPredicate* selectedPredicate = [NSPredicate predicateWithFormat:@"type == %@", selectedCategory];
  NSArray* selectedLocations = [self.CDLocations filteredArrayUsingPredicate:selectedPredicate];
  
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  SelectNewDefaultViewController* snd = [storyboard instantiateViewControllerWithIdentifier:@"SelectNewDefault"];
  
  [snd setLocations:selectedLocations];
  [snd setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  [snd setManagedObjectContext:self.managedObjectContext];
  [snd setManagedObjectModel:self.managedObjectModel];
  
  [self.navigationController pushViewController:snd animated:YES]; 
}

@end
