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

@property (nonatomic) double finalImageScale;

@property (nonatomic) CGPoint finalImageTranslation;

@end

@implementation FinalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.finalImageView.image = self.finalImage;
	UIImageWriteToSavedPhotosAlbum(self.finalImage, nil, nil, nil);
    
    self.finalImageScale = 1.0;
    self.finalImageTranslation = CGPointMake(0, 0);
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
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        self.finalImageScale *= sender.scale;
    }
    else
    {
        self.finalImageView.transform = CGAffineTransformMakeScale(self.finalImageScale * sender.scale,
                                                                         self.finalImageScale * sender.scale);
    }
}

- (IBAction)panRecognizer:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        self.finalImageTranslation = CGPointMake(self.finalImageTranslation.x + translation.x,
                                                 self.finalImageTranslation.y + translation.y);
    }
    else
    {
        self.finalImageView.transform = CGAffineTransformMakeTranslation(self.finalImageTranslation.x + translation.x,
                                                                     self.finalImageTranslation.y + translation.y);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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
