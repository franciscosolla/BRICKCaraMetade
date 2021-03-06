//
//  ResultViewController.h
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 25/03/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (strong, nonatomic) UIImage *face;

@property (nonatomic) double sliderStatus;

@property (nonatomic) double cropperStatus;

@property (nonatomic) BOOL fromLibrary;

@property (strong, nonatomic) UIImage *finalImage;

@end
