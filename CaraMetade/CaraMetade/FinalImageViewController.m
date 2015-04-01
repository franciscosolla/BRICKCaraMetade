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

@property (weak, nonatomic) IBOutlet UIView *finalImageContainer;

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

#pragma mark - Gestures

- (IBAction)pinchRecognizer:(UIPinchGestureRecognizer*)sender
{
    double scale;
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        self.finalImageScale *= sender.scale;
    }
    else
    {
        scale = self.finalImageScale * sender.scale;
        
        if (scale > 3.0)
        {
            sender.scale = 3.0/self.finalImageScale;
            scale = self.finalImageScale * sender.scale;
        }
        else if (scale < 0.3)
        {
            sender.scale = 0.3/self.finalImageScale;
            scale = self.finalImageScale * sender.scale;
        }
        
        self.finalImageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (IBAction)panRecognizer:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
    
    self.finalImageView.center = CGPointMake(self.finalImageView.center.x+translation.x ,self.finalImageView.center.y+translation.y);
    [sender setTranslation:CGPointZero inView:self.view];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - Back Button

- (IBAction)takeAnotherImage:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender
{
    NSArray *objectsToShare = [NSArray arrayWithObjects:self.finalImage, nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeSaveToCameraRoll];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
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
