//
//  CategoriesViewController.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "LocationListViewController.h"

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* locations;

@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

@end
