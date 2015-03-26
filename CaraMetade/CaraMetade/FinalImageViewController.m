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

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchReconizer;

@property (nonatomic) double lastScale;

@end

@implementation FinalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.finalImageView.image = self.finalImage;
	UIImageWriteToSavedPhotosAlbum(self.finalImage, nil, nil, nil);
    
    //UIPinchGestureRecognizer *pinchReconizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchReconizer)];
    //pinchReconizer.delegate = self;
    //[self.finalImageView addGestureRecognizer:pinchReconizer];
    //self.lastScale = 1.0;
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
/*
#pragma mark - Zoom

- (void)pinchReconizer:(UIPinchGestureRecognizer*) reconizer
{
    CGFloat scale = self.lastScale *reconizer.scale;
    
    CGAffineTransform tr = CGAffineTransformScale(self.finalImageView.transform, scale, scale);
    self.finalImageView.transform =tr;
    
    if(reconizer.state == UIGestureRecognizerStateBegan)
    {
        _lastScale = scale;
        return;
    }
}*/
    

@end
