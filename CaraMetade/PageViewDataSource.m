//
//  PageViewDataSource.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 02/04/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "PageViewDataSource.h"

@interface PageViewDataSource ()

@end

@implementation PageViewDataSource

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_tutorialImageFilenames = @[@"page1.png",@"page2.png",@"page3.png",@"page4.png"];
	_tutorialTexts = @[NSLocalizedString(@"page1", nil),NSLocalizedString(@"page2", nil),NSLocalizedString(@"page3", nil),NSLocalizedString(@"page4", nil)];
}

// In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
// For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger index = ((TutorialContentController*) viewController).index;
	
	if ((index == 0) || (index == NSNotFound)) {
		return nil;
	}
	
	index--;
	return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = ((TutorialContentController*) viewController).index;
	
	if (index == NSNotFound) {
		return nil;
	}
	
	index++;
	if (index == [self.tutorialTexts count]) {
		return nil;
	}
	return [self viewControllerAtIndex:index];
}

- (TutorialContentController *)viewControllerAtIndex:(NSUInteger)index
{
	if (([self.tutorialTexts count] == 0) || (index >= [self.tutorialTexts count])) {
		return nil;
	}
	
	// Create a new view controller and pass suitable data.
	TutorialContentController *tutorialContentController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentController"];
	tutorialContentController.tutorialImageFilename = self.tutorialImageFilenames[index];
	tutorialContentController.tutorialLabelText = self.tutorialTexts[index];
	tutorialContentController.index = index;
	
	return tutorialContentController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
