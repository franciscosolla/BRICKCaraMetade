//
//  ViewController.h
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 23/03/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TutorialContentController.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic) BOOL frontCameraActive;

@property (strong, nonatomic) UIPageViewController *tutorialPageController;

@property (strong, nonatomic) NSArray *tutorialTexts;

@property (strong, nonatomic) NSArray *tutorialImageFilenames;

@end

