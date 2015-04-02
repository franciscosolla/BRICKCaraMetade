//
//  StartViewController.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 02/04/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Page View Controller initialization
	
	_tutorialImageFilenames = @[@"page1.png",@"page2.png",@"page3.png",@"page4.png"];
	_tutorialTexts = @[NSLocalizedString(@"page1", nil),NSLocalizedString(@"page2", nil),NSLocalizedString(@"page3", nil),NSLocalizedString(@"page4", nil)];
	
	self.tutorialPageController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageController"];
	self.tutorialPageController.dataSource = self;
	
	TutorialContentController *startingViewController = [self viewControllerAtIndex:0];
	NSArray *viewControllers = @[startingViewController];
	[self.tutorialPageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
	// Change the size of page view controller
	self.tutorialPageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	[self addChildViewController:_tutorialPageController];
	[self.view addSubview:_tutorialPageController.view];
	[self.tutorialPageController didMoveToParentViewController:self];
	
}

#pragma mark - Tutorial Page View Methods

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

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return [self.tutorialTexts count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return 0;
}

- (IBAction)finishButton:(id)sender {
	[self performSegueWithIdentifier:@"StartApp" sender:nil];
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
