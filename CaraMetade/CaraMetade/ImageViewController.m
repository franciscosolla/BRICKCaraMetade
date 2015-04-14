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

@interface ImageViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *viewWithAllImageObjects;

@property (weak, nonatomic) IBOutlet UISlider *sliderLine;

@property (weak, nonatomic) IBOutlet UISlider *rightCropper;

@property (weak, nonatomic) IBOutlet UISlider *leftCropper;

@property (nonatomic) CGFloat imageViewRotation;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set the view and imageview backgrounds to cler.
	self.viewWithAllImageObjects.backgroundColor = [UIColor clearColor];
	self.imageView.backgroundColor = [UIColor clearColor];
	
	// Set the initial rotation and scale.
    self.imageViewRotation = 0;
	
    // Loads the image on the ImageView..
	self.imageView.image = self.image;
    
	// Draws the divisor middle line.
	
        UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBFillColor(context, 1.0, 0.5, 0, 1.0);
    
        CGRect rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
        
        CGContextFillRect(context, rect);
    
        UIImage *line = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [self.sliderLine setThumbImage:line forState:UIControlStateNormal];
        [self.sliderLine setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
        [self.sliderLine setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
        [self.sliderLine setValue:self.sliderStatus];
    
    // ********************************
    
    // Draws the divisor right line.
    
    UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
    
    rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
    
    CGContextFillRect(context, rect);
    
    UIImage *rightLine = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.rightCropper setThumbImage:rightLine forState:UIControlStateNormal];
    [self.rightCropper setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.rightCropper setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.rightCropper setValue:self.sliderStatus + self.cropperStatus];
    
    // ********************************
    
    // Draws the divisor left line.
    
    UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.viewWithAllImageObjects.frame.size.height));
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
    
    rect = CGRectMake(0, 0, 3.0f, self.viewWithAllImageObjects.frame.size.height);
    
    CGContextFillRect(context, rect);
    
    UIImage *leftLine = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.leftCropper setThumbImage:leftLine forState:UIControlStateNormal];
    [self.leftCropper setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.leftCropper setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.leftCropper setValue:self.sliderStatus - self.cropperStatus];
    
    // ********************************
    
}

#pragma mark - Divisor and crop lines

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

#pragma mark - Rotation gesture

- (IBAction)rotationRecognizer:(UIRotationGestureRecognizer*)sender
{
	if (self.imageViewRotation + sender.rotation <= 0.3f && self.imageViewRotation + sender.rotation >= -0.3f)
	{
		if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
			self.imageViewRotation += sender.rotation;
		else
		{
			float scale = [self scaleForRotation:self.imageViewRotation + sender.rotation];
			self.imageView.transform = CGAffineTransformMakeRotation(self.imageViewRotation + sender.rotation);
			self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
		}
	}
	else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
	{
		if (sender.rotation > 0.3f)
			self.imageViewRotation = 0.3f;
		else if (sender.rotation < -0.3f)
			self.imageViewRotation = -0.3f;
	}
}

#pragma mark - Retake and Ready Buttons

/// Rotates and sends the rotated image to the ResultView.
- (IBAction)readyButton:(id)sender {
	// Rotates the image.
	
	self.image = [self rotatedImageFromImageView:self.imageView rotation:self.imageViewRotation];
	
	// Sends the image tp the REsult View.
 
	ResultViewController *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
	destination.face = self.image;
	destination.sliderStatus = self.sliderLine.value;
	destination.cropperStatus = self.rightCropper.value - self.sliderLine.value;
	destination.fromLibrary = self.fromLibrary;
	
	[self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)retakeButton:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Rotation functions

/// Rotates the image and crops the result for the image to remain rectangular.
- (UIImage *) rotatedImageFromImageView:(UIImageView *)imageView rotation:(CGFloat)angle
{
	
	UIImage *image = imageView.image;
	
	UIImage *auxImage;
	
	CGSize rotatedsize = CGSizeMake((fabs(cosf(angle))*image.size.width)-((fabs(sinf(angle))*image.size.height)),
									((fabs(cosf(angle))*image.size.height)-(fabs(sinf(angle))*image.size.width)));
	
	UIGraphicsBeginImageContext(rotatedsize);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, rotatedsize.width/2, rotatedsize.height/2);
	CGContextRotateCTM(context, angle);
	
	[image drawAtPoint:CGPointMake(-image.size.width/2, -image.size.height/2)];
	
	auxImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return [UIImage imageWithCGImage:auxImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
}

/// Return the scale float for the image rotation.
- (float) scaleForRotation:(CGFloat) angle
{
	float widthAfterCrop = (fabs(cosf(angle))*self.imageView.image.size.width)-(fabs(sinf(angle))*self.imageView.image.size.height);
	
	return self.imageView.image.size.width / widthAfterCrop;
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

