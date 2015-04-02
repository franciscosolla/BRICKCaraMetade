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

@property (weak, nonatomic) IBOutlet UIView *finalImageContainer;

@property (nonatomic) CGSize finalImageProportion;

@property (nonatomic) bool doubleTapZoom;

@end

@implementation FinalImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.finalImageView.image = self.finalImage;
	UIImageWriteToSavedPhotosAlbum(self.finalImage, nil, nil, nil);
    
    self.finalImageScale = 1.0;
    self.finalImageView.center = self.finalImageContainer.center;
    
    if (self.finalImage.size.width > self.finalImage.size.height)
        self.finalImageProportion = CGSizeMake(1.0, self.finalImage.size.height/self.finalImage.size.width);
    else
        self.finalImageProportion = CGSizeMake(self.finalImage.size.width/self.finalImage.size.height, 1.0);
}

#pragma mark - Gestures

- (IBAction)pinchRecognizer:(UIPinchGestureRecognizer*)sender
{
    double scale;
    self.doubleTapZoom = NO;
    
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
        else if (scale < 1.0)
        {
            sender.scale = 1.0/self.finalImageScale;
            scale = self.finalImageScale * sender.scale;
        }
        
        self.finalImageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    UIPanGestureRecognizer *refresh =  [[UIPanGestureRecognizer alloc] init];
    
    [refresh setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self panRecognizer: refresh];
}

- (IBAction)panRecognizer:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
    
    double halfWidth, halfHeight;
    
    if (self.finalImageProportion.width == 1.0)
    {
        halfWidth = self.finalImageView.frame.size.width/2;
        halfHeight = self.finalImageView.frame.size.height*(1.0-self.finalImageProportion.height)/2;
    }
    else
    {
        halfWidth = self.finalImageView.frame.size.width*(1.0-self.finalImageProportion.width)/2;
        halfHeight = self.finalImageView.frame.size.height/2;
    }
    
    if (2*halfWidth > self.finalImageContainer.bounds.size.width)
    {
        if (self.finalImageView.center.x+translation.x+halfWidth < self.finalImageContainer.bounds.size.width)
        {
            self.finalImageView.center = CGPointMake(self.finalImageContainer.bounds.size.width-halfWidth ,self.finalImageView.center.y);
        }
        else if (self.finalImageView.center.x+translation.x-halfWidth > 0)
        {
            self.finalImageView.center = CGPointMake(halfWidth ,self.finalImageView.center.y);
        }
        else
        {
            self.finalImageView.center = CGPointMake(self.finalImageView.center.x+translation.x ,self.finalImageView.center.y);
        }
        
    }
    else
        self.finalImageView.center = CGPointMake(self.finalImageContainer.center.x ,self.finalImageView.center.y);
    
    if (2*halfHeight > self.finalImageContainer.bounds.size.height)
    {
        if (self.finalImageView.center.y+translation.y+halfHeight < self.finalImageContainer.bounds.size.height)
        {
            self.finalImageView.center = CGPointMake(self.finalImageView.center.x, self.finalImageContainer.bounds.size.height-halfHeight);
        }
        else if (self.finalImageView.center.y+translation.y-halfHeight > 0)
        {
            self.finalImageView.center = CGPointMake(self.finalImageView.center.x, halfHeight);
        }
        else
        {
            self.finalImageView.center = CGPointMake(self.finalImageView.center.x, self.finalImageView.center.y+translation.y);
        }
    }
    else
        self.finalImageView.center = CGPointMake(self.finalImageView.center.x, self.finalImageContainer.center.y);
    
    [sender setTranslation:CGPointZero inView:self.view];
}

- (IBAction)tapRecognizer:(UITapGestureRecognizer*)sender
{
    if (self.doubleTapZoom)
    {
        self.finalImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.finalImageView.center = CGPointMake(self.finalImageContainer.center.x, self.finalImageContainer.center.y);
        
        self.doubleTapZoom = NO;
    }
    else
    {
        CGPoint touch = [sender locationInView:nil];
        
        self.finalImageView.transform = CGAffineTransformMakeScale(3.0, 3.0);
        
        UIPanGestureRecognizer *refresh = [[UIPanGestureRecognizer alloc] init];
        
        [refresh setTranslation:CGPointMake(self.finalImageView.center.x >= touch.x ? self.finalImageView.center.x-touch.x : touch.x-self.finalImageView.center.x,
                                           self.finalImageView.center.y >= touch.y ? self.finalImageView.center.y-touch.y : touch.y-self.finalImageView.center.y)
                 inView:self.finalImageContainer];
        
        [self panRecognizer:refresh];
        
        self.doubleTapZoom = YES;
    }
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
