//
//  ImageViewController.m
//  CaraMetade
//
//  Created by Francisco Solla on 3/24/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "ImageViewController.h"
#import "ResultViewController.h"
#import "CameraViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *sliderLine;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// Loads the image on the ImageView..
	self.imageView.image = self.image;
	// Draws the divisor line.
	[self.sliderLine maximumValueImageRectForBounds:self.view.bounds];
	[self.sliderLine setThumbImage:[UIImage imageNamed:@"line.jpg"] forState:UIControlStateNormal];
	[self.sliderLine setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
	[self.sliderLine setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ResultView"])
	{
		ResultViewController *destination = segue.destinationViewController;
		destination.face = self.image;
		destination.sliderStatus = [[NSNumber alloc] initWithFloat:self.sliderLine.value];
	}
	else if ([segue.indentifier isEqualToString:@"RetakePhoto"])
	{
		CameraViewController *destination = segue.destinationViewController;
		destination.frontCameraActive = 
	}
}


- (IBAction)readyButton:(id)sender {
	[self performSegueWithIdentifier:@"ResultView" sender:self];
}

- (IBAction)retakeButton:(id)sender {
	[self performSegueWithIdentifier:@"RetakePhoto" sender:self];
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

