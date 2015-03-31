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

@property (nonatomic) double imageViewRotation;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set the view and imageview backgrounds to cler.
	self.viewWithAllImageObjects.backgroundColor = [UIColor clearColor];
	self.imageView.backgroundColor = [UIColor clearColor];
	
	// Set the initial rotation.
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

#pragma mark - Divisor adn crop lines

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
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
        self.imageViewRotation += sender.rotation;
    else
        self.imageView.transform = CGAffineTransformMakeRotation(self.imageViewRotation + sender.rotation);
	
    //image doesn`t really rotate, just it`s vizualization, study the code in the url: http://stackoverflow.com/questions/10544887/rotating-a-cgimage to fix it
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

#pragma mark - Retake and Ready Buttons

- (IBAction)readyButton:(id)sender {
//	self.image = [self rotatedImageFromImageView:self.imageView];
	[self performSegueWithIdentifier:@"ResultView" sender:self];
}

- (IBAction)retakeButton:(id)sender {
	[self performSegueWithIdentifier:@"RetakePhoto" sender:self];
}

#pragma mark - Rotation functions

// http://stackoverflow.com/questions/2856556/creating-a-uiimage-from-a-rotated-uiimageview/2897625#2897625

- (CGRect) getBoundingRectAfterRotation: (CGRect) rectangle byAngle: (CGFloat) angleOfRotation {
	// Calculate the width and height of the bounding rectangle using basic trig
	CGFloat newWidth = rectangle.size.width * fabs(cosf(angleOfRotation)) + rectangle.size.height * fabs(sinf(angleOfRotation));
	CGFloat newHeight = rectangle.size.height * fabs(cosf(angleOfRotation)) + rectangle.size.width * fabs(sinf(angleOfRotation));
	
	// Calculate the position of the origin
	CGFloat newX = rectangle.origin.x + ((rectangle.size.width - newWidth) / 2);
	CGFloat newY = rectangle.origin.y + ((rectangle.size.height - newHeight) / 2);
	
	// Return the rectangle
	return CGRectMake(newX, newY, newWidth, newHeight);
}

- (UIImage *) rotatedImageFromImageView: (UIImageView *) imageView
{
	UIImage *rotatedImage;
	
	// Get image width, height of the bounding rectangle
	CGRect boundingRect = [self getBoundingRectAfterRotation:imageView.bounds byAngle:self.imageViewRotation];
	
	// Create a graphics context the size of the bounding rectangle
	UIGraphicsBeginImageContext(boundingRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGAffineTransform transform = CGAffineTransformIdentity;
//	transform = CGAffineTransformTranslate(transform, boundingRect.size.width/2, boundingRect.size.height/2);
	transform = CGAffineTransformRotate(transform, self.imageViewRotation);
	transform = CGAffineTransformScale(transform, 1.0, -1.0);
	
	CGContextConcatCTM(context, transform);
	
	// Draw the image into the context
	CGContextDrawImage(context, CGRectMake(-imageView.image.size.width/2, -imageView.image.size.height/2, imageView.image.size.width, imageView.image.size.height), imageView.image.CGImage);
	
	// Get an image from the context
	rotatedImage = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context)];
	
	// Clean up
	UIGraphicsEndImageContext();
	return rotatedImage;
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

