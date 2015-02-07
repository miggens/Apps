//
//  ViewController.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/4/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CategoriesViewController.h"
#import "LocationHelper.h"
#import "DefaultLocation.h"
#import "Reachability.h"
#import "Location.h"
#import "Downloads.h"

@interface ViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSXMLParserDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

@property (strong, nonatomic) NSDictionary* downloadRequests;

@end

