//
//  ChangeDefaultLocationViewController.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 1/9/15.
//  Copyright (c) 2015 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeDefaultLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* CDTypes;
@property (strong, nonatomic) NSDictionary* CDTitles;
@property (strong, nonatomic) NSArray* CDLocations;

@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

@end
