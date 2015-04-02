//
//  ResultViewController.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 25/03/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "ResultViewController.h"
#import "FinalImageViewController.h"
#import "ImageViewController.h"
#import "CameraViewController.h"

@interface ResultViewController()

@property (weak, nonatomic) IBOutlet UIImageView *leftSideImage;

@property (weak, nonatomic) IBOutlet UIImageView *rightSideImage;

@end

@implementation ResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	// Loads the image ad splits in half and displays in right and left view.
	
    CGImageRef leftImage, rightImage;
	
	if (self.fromLibrary)
	{
		if (self.sliderStatus >= 0.5)
		{
            rightImage = CGImageCreateWithImageInRect(self.face.CGImage,
                                                      CGRectMake(self.face.size.width - (2 * self.cropperStatus * self.face.size.width),
                                                                 0,
                                                                 self.face.size.width * self.cropperStatus,
                                                                 self.face.size.height));
            
            leftImage = CGImageCreateWithImageInRect(self.face.CGImage,
                                                     CGRectMake(self.face.size.width - (self.cropperStatus * self.face.size.width),
                                                                0,
                                                                self.face.size.width * self.cropperStatus,
                                                                self.face.size.height));
		}
		else
		{
            rightImage = CGImageCreateWithImageInRect(self.face.CGImage,
                                                      CGRectMake(0,
                                                                 0,
                                                                 self.face.size.width * self.cropperStatus,
                                                                 self.face.size.height));
            
            leftImage = CGImageCreateWithImageInRect(self.face.CGImage,
                                                     CGRectMake((self.cropperStatus * self.face.size.width),
                                                                0,
                                                                self.face.size.width * self.cropperStatus,
                                                                self.face.size.height));
		}
	}
	else
	{
		if (self.sliderStatus >= 0.5)
		{
			leftImage = CGImageCreateWithImageInRect(self.face.CGImage,
													 CGRectMake(0,
																0,
																self.face.size.height,
																self.face.size.width * self.cropperStatus));
			
			rightImage = CGImageCreateWithImageInRect(self.face.CGImage,
													  CGRectMake(0,
																 (self.cropperStatus * self.face.size.width),
																 self.face.size.height,
																 self.face.size.width * self.cropperStatus));
		}
		else
		{
			leftImage = CGImageCreateWithImageInRect(self.face.CGImage,
													 CGRectMake(0,
																self.face.size.width - (2 * self.cropperStatus * self.face.size.width),
																self.face.size.height,
																self.face.size.width * self.cropperStatus));
			
			rightImage = CGImageCreateWithImageInRect(self.face.CGImage,
													  CGRectMake(0,
																 self.face.size.width - (self.cropperStatus * self.face.size.width),
																 self.face.size.height,
																 self.face.size.width * self.cropperStatus));
		}
	}
    
    self.leftSideImage.image = [UIImage imageWithCGImage:leftImage scale:1 orientation:self.face.imageOrientation];
	self.rightSideImage.image = [UIImage imageWithCGImage:rightImage scale:1 orientation:self.face.imageOrientation];
    
    // build the final left side image
    
        CGSize size = CGSizeMake(2*self.leftSideImage.image.size.width, self.leftSideImage.image.size.height);
        UIGraphicsBeginImageContext(size);
        
        CGPoint pointImg1 = CGPointMake(0,0);
        if (self.fromLibrary)
            [[[UIImage alloc] initWithCGImage:leftImage scale:1 orientation:UIImageOrientationUpMirrored] drawAtPoint: pointImg1];
        else
            [[[UIImage alloc] initWithCGImage:leftImage scale:1 orientation:UIImageOrientationLeftMirrored] drawAtPoint: pointImg1];
        
        CGPoint pointImg2 = CGPointMake(self.leftSideImage.image.size.width,0);
        [self.leftSideImage.image drawAtPoint:pointImg2];
        
        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.leftSideImage.image = result;
	
    // ********************************
    
    // build the final right side image
    
        size = CGSizeMake(2*self.rightSideImage.image.size.width, self.rightSideImage.image.size.height);
        UIGraphicsBeginImageContext(size);
        
        pointImg1 = CGPointMake(0,0);
        [self.rightSideImage.image drawAtPoint:pointImg1];
        
        pointImg2 = CGPointMake(self.rightSideImage.image.size.width,0);
        if (self.fromLibrary)
            [[[UIImage alloc] initWithCGImage:rightImage scale:1 orientation:UIImageOrientationUpMirrored] drawAtPoint: pointImg2];
        else
            [[[UIImage alloc] initWithCGImage:rightImage scale:1 orientation:UIImageOrientationLeftMirrored] drawAtPoint: pointImg2];
    
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightSideImage.image = result;
	
    // ********************************
}

#pragma mark - Buttons

- (IBAction)acceptImage:(id)sender
{
	
	FinalImageViewController * destination = [self.storyboard instantiateViewControllerWithIdentifier:@"FinalImageViewController"];
	
	// build the FINAL image
	
	CGSize size = CGSizeMake(self.rightSideImage.image.size.width+self.leftSideImage.image.size.width, self.leftSideImage.image.size.height);
	UIGraphicsBeginImageContext(size);
	
    
        CGPoint pointImg1 = CGPointMake(0,0);
        [self.rightSideImage.image drawAtPoint:pointImg1];
        
        CGPoint pointImg2 = CGPointMake(self.rightSideImage.image.size.width,0);
        [self.leftSideImage.image drawAtPoint:pointImg2];
        
    
	
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	destination.finalImage = result;
	
	// *********************
	
    [self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)retakeImage:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editImage:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
