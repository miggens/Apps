//
//  MapViewController.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/5/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import "InfoView.h"
#import "ChangeDefaultView.h"
#import "DefaultLocation.h"
#import "PhoneAnnotation.h"
#import "DefaultAnnotation.h"
#import "SelectedLocation.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Location* selectedLocation; 
@property (strong, nonatomic) NSArray* phones; 
@property (strong, nonatomic) NSArray* locationsList;
@property (strong, nonatomic) NSArray* CDTypes;
@property (strong, nonatomic) NSDictionary* CDTitles;
@property (strong, nonatomic) NSArray* CDLocations; 

@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

- (void)resetDefaultLocation:(DefaultAnnotation*)def;

@end
