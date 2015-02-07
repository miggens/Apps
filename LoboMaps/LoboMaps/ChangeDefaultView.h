//
//  ChangeDefaultView.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/10/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface ChangeDefaultView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIViewController* presentingController;
@property (strong, nonatomic) NSArray* types;
@property (strong, nonatomic) NSDictionary* titles;
@property (strong, nonatomic) NSArray* locations;

- (id)initWithFrame:(CGRect)frame newLocation:(NSString*)newLocation; 

@end
