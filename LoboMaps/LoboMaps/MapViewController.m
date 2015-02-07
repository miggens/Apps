//
//  MapViewController.m
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/5/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import "MapViewController.h"
#import "ChangeDefaultLocationViewController.h"

NSString* const kPhoneIdentifier    = @"Phone";
NSString* const kBuildingIdentifier = @"Building";
NSString* const kDefaultIdentifier  = @"Default";

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property UIButton* infoButton;
@property DefaultAnnotation* defaultAnn;
@property UIBarButtonItem* userLocationButtonOff;
@property UIBarButtonItem* userLocationButtonOn;
@property CLLocationCoordinate2D targetLocation;
@property CLAuthorizationStatus currentAuthStatus;
@property MKUserLocation* uLocation;
@property MKMapRect initialRect;
@property BOOL trackingUser;


@end

@implementation MapViewController

@synthesize selectedLocation;
@synthesize phones;
@synthesize locationsList;
@synthesize CDTypes;
@synthesize CDTitles;
@synthesize CDLocations;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

//35.084319,-106.619781

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.userLocationButtonOff = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                        imageNamed:@"u_location_button.png"]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(userLocationButtonDown)];
  self.userLocationButtonOff.title = @"OFF";
  self.userLocationButtonOn = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                          imageNamed:@"u_location_on.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(userLocationButtonDown)];
  self.userLocationButtonOn.title = @"ON";
  self.navigationItem.rightBarButtonItem = self.userLocationButtonOn;
  
  self.title = selectedLocation.title;
  
  if ([self.title containsString:@"Lactation Station: "])
  {
    self.title = [selectedLocation.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
  }
  
  self.mapView.delegate = self;
  self.trackingUser = NO;
  
  // Do any additional setup after loading the view.
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter  = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
  [self.locationManager requestWhenInUseAuthorization];

  NSError* fetchError;
  NSFetchRequest* defaultLocationFetch = [[NSFetchRequest alloc] init];
  NSEntityDescription* description = [NSEntityDescription entityForName:@"DefaultLocation" inManagedObjectContext:self.managedObjectContext];
  [defaultLocationFetch setEntity:description];
  
  NSArray* fetchArray = [self.managedObjectContext executeFetchRequest:defaultLocationFetch
                                                                 error:&fetchError];
  DefaultLocation* defaultLocation = [fetchArray firstObject];

  CLLocationCoordinate2D defaultCoordinate = CLLocationCoordinate2DMake([defaultLocation.latitude doubleValue], [defaultLocation.longitude doubleValue]);
  
  
  NSMutableArray* dAnnotations = [NSMutableArray array];
  
  DefaultAnnotation* defaultAnnotation = [[DefaultAnnotation alloc] initWithCoordinates:defaultCoordinate title:defaultLocation.title subTitle:defaultLocation.nickname];
  self.defaultAnn = defaultAnnotation;
  [dAnnotations addObject:defaultAnnotation];
  
  [self.mapView addAnnotation:defaultAnnotation];
  
  for (Location* phone in self.phones)
  {
    PhoneAnnotation* pa = [[PhoneAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake([phone.latitude doubleValue], [phone.longitude doubleValue])
                                                                 title:@"Blue Phone"
                                                              subTitle:@""];
    [self.mapView addAnnotation:pa];
  }
  
  SelectedLocation* l;
  if (self.selectedLocation)
  {
    NSString* title = self.selectedLocation.title;
    
    if ([title containsString:@"Lactation Station: "])
    {
      title = [self.selectedLocation.title stringByReplacingOccurrencesOfString:@"Lactation Station: " withString:@""];
    }
    
    self.targetLocation = CLLocationCoordinate2DMake([self.selectedLocation.latitude doubleValue], [self.selectedLocation.longitude doubleValue]);
  
    l = [[SelectedLocation alloc] initWithCoordinates:self.targetLocation
                                                title:title
                                            subTitle:@""];

    [self.mapView addAnnotation:l];
    [dAnnotations addObject:l];
  }
  
  MKMapRect zoomRect = MKMapRectNull;
  for (id <MKAnnotation> annotation in self.mapView.annotations)
  {
    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
    if (MKMapRectIsNull(zoomRect))
    {
      zoomRect = pointRect;
    }
    else
    {
      zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
  }
  zoomRect.origin.x += 10000.0;
  
  self.initialRect = zoomRect;
  [self.mapView setVisibleMapRect:zoomRect
                         animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNeedsStatusBarAppearanceUpdate];
  
  self.title = self.selectedLocation.title; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetDefaultLocation:(DefaultAnnotation *)def
{
  [self.mapView removeAnnotation:self.defaultAnn];
  
  self.defaultAnn = def;
  [self.mapView addAnnotation:self.defaultAnn];
  [self.mapView selectAnnotation:self.defaultAnn animated:YES];
  
  MKMapPoint annotationPoint = MKMapPointForCoordinate(self.defaultAnn.coordinate);
  MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
  
  self.initialRect = MKMapRectUnion(self.initialRect, pointRect);
  
  
  [self.mapView setVisibleMapRect:self.initialRect
                         animated:YES];
}

- (void)displayLocationInfo
{
  UIAlertAction* dismiss  = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
  {
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
  }];
  
  UIAlertController* info;
  
  if ([selectedLocation class] == [Location class])
  {
    info = [UIAlertController alertControllerWithTitle:self.selectedLocation.title
                                                                  message:[self santizedString:self.selectedLocation.snippet]
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
  }
  else
  {
    //need to fetch a location instance
  }
  
  [info addAction:dismiss];

  [self presentViewController:info animated:YES completion:^{
    
  }];
  
}

- (void)updateDefaultLocation
{
  UIAlertAction* dismiss  = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
  {
    [self dismissViewControllerAnimated:YES completion:^
    {
     
    }];
  }];
  
  UIAlertAction* changeDefaultLocationAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  {

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChangeDefaultLocationViewController* cdl = [storyboard instantiateViewControllerWithIdentifier:@"ChangeDefault"];
    
    [cdl setCDLocations:self.CDLocations];
    [cdl setCDTitles:self.CDTitles];
    [cdl setCDTypes:self.CDTypes];
    
    [cdl setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    [cdl setManagedObjectContext:self.managedObjectContext];
    [cdl setManagedObjectModel:self.managedObjectModel];
    
    self.title = @"";
    [self.navigationController pushViewController:cdl animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^
    {

    }];
  }];
  
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change Default Location?"
                                                                 message:@""
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
  [alert addAction:changeDefaultLocationAction];
  [alert addAction:dismiss];
  
  [self presentViewController:alert animated:YES completion:^{
    
  }];
}

- (void)userLocationButtonDown
{
  // If Location Services are disabled, restricted or denied.
  if ((![CLLocationManager locationServicesEnabled])
      || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
      || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
  {
    // Send the user to the location settings preferences
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Services"
                                                    message:@"Location Services can be enabled via settings"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Settings", nil];
    [alert show];
    return;
  }
  
  if (!self.trackingUser)
  {
    [self.locationManager startUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
    self.trackingUser = YES;
    self.navigationItem.rightBarButtonItem = self.userLocationButtonOn;
    
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.locationManager.location.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
    
    MKMapRect zoomRect = MKMapRectUnion(self.initialRect, pointRect);
    [self.mapView setVisibleMapRect:zoomRect
                           animated:YES];
  }
  else
  {
    [self.locationManager stopUpdatingLocation];
    [self.mapView setShowsUserLocation:NO];
    self.trackingUser = NO;
    self.navigationItem.rightBarButtonItem = self.userLocationButtonOff;
    
    [self.mapView setVisibleMapRect:self.initialRect
                           animated:YES];
  }
}

- (void)openSettings
{
  BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
  if (canOpenSettings) {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
  }
}

- (NSString*)santizedString:(NSString*) dirtyString
{
  if (dirtyString == nil) return @"No Info";
  NSError* error;
  NSString* breakPattern = @"\\<br\\>";
  NSString* aPattern     = @"\\<[^\\>]*\\>";
  NSString* ibPattern   = @"\\<script[^>]*\\>\\s*([^\\<]*)\\s*\\<\\/script\\>";
  
  NSRegularExpression* breakRegex = [NSRegularExpression regularExpressionWithPattern:breakPattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSRegularExpression* tagPattern = [NSRegularExpression regularExpressionWithPattern:aPattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSRegularExpression* betweenTagPattern = [NSRegularExpression regularExpressionWithPattern:ibPattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSRange breakRange = NSMakeRange(0, [dirtyString length]);
  
  NSString* tmp = [breakRegex stringByReplacingMatchesInString:dirtyString options:NSMatchingReportProgress range:breakRange withTemplate:@"\n"];
  
  NSString* tmp2 = [betweenTagPattern stringByReplacingMatchesInString:tmp
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, [tmp length])
                                                          withTemplate:@""];

  return [tagPattern stringByReplacingMatchesInString:tmp2
                                              options:NSMatchingReportProgress
                                                range:NSMakeRange(0, [tmp2 length])
                                         withTemplate:@""];
}

#pragma mark Map and CoreLocation Delagate Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  self.uLocation = userLocation;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
  
  MKAnnotationView* view = nil;
  
  if ([annotation isKindOfClass:[PhoneAnnotation class]])
  {
    view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPhoneIdentifier];
    if (!view)
    {
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                          reuseIdentifier:kPhoneIdentifier];
      
      view.image = [UIImage imageNamed:@"bp_annotation.png"];
      
      view.canShowCallout = YES;
    }
  }
  
  if ([annotation isKindOfClass:[SelectedLocation class]])
  {
    view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kBuildingIdentifier];
    if (!view)
    {
      
      UIButton* rightCalloutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
      rightCalloutButton.tintColor = [UIColor blackColor];
      
      [rightCalloutButton addTarget:self
                             action:@selector(displayLocationInfo)
                   forControlEvents:UIControlEventTouchUpInside];
      
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                          reuseIdentifier:kBuildingIdentifier];
      
      view.image = [UIImage imageNamed:@"building_annotation.png"];
      view.canShowCallout = YES;

      view.rightCalloutAccessoryView = rightCalloutButton;
      
      
      UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unm_logo.png"]];
      imageView.frame = CGRectMake(0, 10, 32, 32);
      view.leftCalloutAccessoryView = imageView;
      //self.infoButton = rightCalloutButton;
    }
  }
  
  if ([annotation isKindOfClass:[DefaultAnnotation class]])
  {
    view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kDefaultIdentifier];
    if (!view)
    {
      UIButton* rightCalloutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
      rightCalloutButton.tintColor = [UIColor blackColor];
      
      [rightCalloutButton addTarget:self
                             action:@selector(updateDefaultLocation)
                   forControlEvents:UIControlEventTouchUpInside];
      
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                          reuseIdentifier:kDefaultIdentifier];
      view.canShowCallout = YES;
      view.image = [UIImage imageNamed:@"default_annotation.png"];
      view.rightCalloutAccessoryView = rightCalloutButton;
    }
  }
  
  return view;
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
  
  for (MKAnnotationView* view in views)
  {
   
   if ([view.reuseIdentifier compare:kBuildingIdentifier] == NSOrderedSame)
   {
    
    CGRect endFrame = view.frame;
    view.frame = CGRectOffset(view.frame, 0.0, -500.0);
    [UIView animateWithDuration:0.5
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
       view.frame = endFrame;
     }
                     completion:^(BOOL finished)
     {
       if (finished)
       {
         [UIView animateWithDuration:0.1 animations:^(void)
          {
            view.transform = CGAffineTransformMakeScale(1.0, 0.9);
          }
                          completion:^(BOOL finished)
          {
            if (finished)
            {
              [UIView animateWithDuration:0.1
                               animations:^(void)
               {
                 view.transform = CGAffineTransformIdentity;
                 [self.mapView selectAnnotation:view.annotation animated:YES];
               }];
            }
          }];
       }
     }];
    }
  }
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex)
  {
    [self openSettings];
  }
}

@end
