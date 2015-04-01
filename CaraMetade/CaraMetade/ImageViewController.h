//
//  ImageViewController.h
//  CaraMetade
//
//  Created by Francisco Solla on 3/24/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@property (nonatomic) double sliderStatus;

@property (nonatomic) double cropperStatus;

@property (nonatomic) BOOL fromLibrary;

@end
