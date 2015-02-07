//
//  InfoView.h
//  LoboMaps
//
//  Created by Alfred Sanchez on 12/10/14.
//  Copyright (c) 2014 Alfred Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "Location.h"

@interface InfoView : UIView

@property (strong, nonatomic) UIViewController* presentingController;

- (id)initWithFrame:(CGRect)frame displayInfo:(Location*) info;

@end
