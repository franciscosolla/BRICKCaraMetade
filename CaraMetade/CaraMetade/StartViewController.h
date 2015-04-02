//
//  StartViewController.h
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 02/04/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialContentController.h"

@interface StartViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *tutorialPageController;

@property (strong, nonatomic) NSArray *tutorialTexts;

@property (strong, nonatomic) NSArray *tutorialImageFilenames;

@property BOOL fromNavigation;

@end
