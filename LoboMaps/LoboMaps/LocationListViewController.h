//
//  LocationListViewController.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/5/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Location.h"


@interface LocationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* locationsList;
@property (strong, nonatomic) NSArray* phoneList;
@property (strong, nonatomic) NSString* displayTitle;
@property (strong, nonatomic) NSArray* CDTypes;
@property (strong, nonatomic) NSDictionary* CDTitles;
@property (strong, nonatomic) NSArray* CDLocations;

@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

@end
