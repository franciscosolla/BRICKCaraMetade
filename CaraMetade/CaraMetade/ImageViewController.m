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

@property (weak, nonatomic) IBOutlet UIView *viewWithAllImageObjects;

@property (weak, nonatomic) IBOutlet UISlider *sliderLine;

@property (weak, nonatomic) IBOutlet UISlider *rightCropper;

@property (weak, nonatomic) IBOutlet UISlider *leftCropper;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    // Loads the image on the ImageView..
	self.imageView.image = self.image;
    
	// Draws the divisor middle line.
	
        UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBFillColor(context, 1.0, 0.5, 0, 1.0);
        
        CGRect rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
        
        CGContextFillRect(context, rect);
        
        CGContextStrokeRect(context, rect);
        
        UIImage *line = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [self.sliderLine setThumbImage:line forState:UIControlStateNormal];
        [self.sliderLine setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
        [self.sliderLine setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
        [self.sliderLine setValue:self.sliderStatus];
    
    // ********************************
    
    // Draws the divisor middle line.
    
    UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0, 0.5, 0, 1.0);
    
    rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
    
    CGContextFillRect(context, rect);
    
    CGContextStrokeRect(context, rect);
    
    UIImage *rightLine = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.rightCropper setThumbImage:rightLine forState:UIControlStateNormal];
    [self.rightCropper setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.rightCropper setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.rightCropper setValue:self.sliderStatus + self.cropperStatus];
    
    // ********************************
    
    // Draws the divisor middle line.
    
    UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0, 0.5, 0, 1.0);
    
    rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
    
    CGContextFillRect(context, rect);
    
    CGContextStrokeRect(context, rect);
    
    UIImage *leftLine = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.leftCropper setThumbImage:leftLine forState:UIControlStateNormal];
    [self.leftCropper setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.leftCropper setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.leftCropper setValue:self.sliderStatus - self.cropperStatus];
    
    // ********************************
    
}

- (IBAction)leftCropperValueChanged:(id)sender
{
    if (self.leftCropper.value <= self.sliderLine.value-0.1)
    {
        self.cropperStatus = self.sliderLine.value - self.leftCropper.value;
    }
    else
    {
        self.cropperStatus = 0.1;
        [self.leftCropper setValue:self.sliderLine.value - self.cropperStatus ];
    }
    
    [self.rightCropper setValue:self.sliderLine.value + self.cropperStatus];
}

- (IBAction)rightCropperValueChanged:(id)sender
{
    if (self.rightCropper.value >= self.sliderLine.value+0.1)
    {
        self.cropperStatus = self.sliderLine.value - self.rightCropper.value;
    }
    else
    {
        self.cropperStatus = 0.1;
        [self.rightCropper setValue:self.sliderLine.value - self.cropperStatus ];
    }
    
    [self.leftCropper setValue:self.sliderLine.value - self.cropperStatus];
}


- (IBAction)sliderLineValueChanged:(id)sender
{
    if (self.sliderLine.value > 0.9)
    {
        [self.sliderLine setValue:0.9];
    }
    else if (self.sliderLine.value < 0.1)
    {
        [self.sliderLine setValue:0.1];
    }
    
    self.cropperStatus = self.sliderLine.value  > 0.5 ? 1.0-self.sliderLine.value : self.sliderLine.value;
    
    [self.rightCropper setValue:self.sliderLine.value+self.cropperStatus animated:YES];
    [self.leftCropper setValue:self.sliderLine.value-self.cropperStatus animated:YES];
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
		destination.sliderStatus = self.sliderLine.value;
		destination.frontCamera = self.frontCamera;
        destination.cropperStatus = self.rightCropper.value - self.sliderLine.value;
	}
	else if ([segue.identifier isEqualToString:@"RetakePhoto"])
	{
		CameraViewController *destination = segue.destinationViewController;
		destination.frontCameraActive = self.frontCamera;
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

