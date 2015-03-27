//
//  FinalImageViewController.m
//  CaraMetade
//
//  Created by Francisco Solla on 3/25/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "FinalImageViewController.h"
#import "CameraViewController.h"

@interface FinalImageViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *finalImageView;

@end

@implementation FinalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.finalImageView.image = self.finalImage;
	UIImageWriteToSavedPhotosAlbum(self.finalImage, nil, nil, nil);
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CameraView"])
	{
		CameraViewController *destination = segue.destinationViewController;
		destination.frontCameraActive = self.frontCamera;
	}
}

- (IBAction)pinchRecognizer:(UIPinchGestureRecognizer*)sender
{
    CGAffineTransform tr = CGAffineTransformScale(self.finalImageView.transform, sender.scale, sender.scale);
    self.finalImageView.transform = tr;
}

- (IBAction)panRecognizer:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
    CGAffineTransform tr = CGAffineTransformTranslate(self.finalImageView.transform, translation.x*0.06, translation.y*0.06);
    self.finalImageView.transform = tr;
}

#pragma mark - Back Button

- (IBAction)takeAnotherImage:(id)sender
{
    [self performSegueWithIdentifier:@"CameraView" sender:self];
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

#pragma mark - Zoom


    

@end
