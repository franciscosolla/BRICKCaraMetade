//
//  TutorialContentController.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 02/04/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "TutorialContentController.h"

@interface TutorialContentController ()

@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;

@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;

@end

@implementation TutorialContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set text and image.
	self.tutorialLabel.text = self.tutorialLabelText;
	self.tutorialLabel.numberOfLines = 0;
	self.tutorialImageView.image = [UIImage imageNamed:self.tutorialImageFilename];
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
