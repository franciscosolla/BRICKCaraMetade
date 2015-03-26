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
	CGImageRef leftImage = CGImageCreateWithImageInRect(self.face.CGImage, CGRectMake(0, 0, self.face.size.height, (self.face.size.width * ( 1.0 -self.sliderStatus))));
	CGImageRef rightImage = CGImageCreateWithImageInRect(self.face.CGImage, CGRectMake(0, (self.face.size.width * (1.0-self.sliderStatus)), self.face.size.height, (self.face.size.width*self.sliderStatus)));
    
    self.leftSideImage.image = [UIImage imageWithCGImage:leftImage scale:1 orientation:self.face.imageOrientation];
	self.rightSideImage.image = [UIImage imageWithCGImage:rightImage scale:1 orientation:self.face.imageOrientation];
        
    // build the final left side image
    
        CGSize size = CGSizeMake(2*self.leftSideImage.image.size.width, self.leftSideImage.image.size.height);
        UIGraphicsBeginImageContext(size);
        
        CGPoint pointImg1 = CGPointMake(0,0);
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
        [[[UIImage alloc] initWithCGImage:rightImage scale:1 orientation:UIImageOrientationLeftMirrored] drawAtPoint: pointImg2];
    
        
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rightSideImage.image = result;
    
    // ********************************
}

#pragma mark - Prepare Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FinalImageView"])
    {
        FinalImageViewController * destination = segue.destinationViewController;
    
        // build the FINAL image
        
        float width, height;
        
        if (self.rightSideImage.image.size.width > self.leftSideImage.image.size.width)
            width = self.rightSideImage.image.size.width;
        else
            width = self.leftSideImage.image.size.width;
        
        height = self.rightSideImage.image.size.height + self.leftSideImage.image.size.height;
        
        CGSize size = CGSizeMake(width, height);
        UIGraphicsBeginImageContext(size);
        
        if (self.leftSideImage.image.size.width >= self.rightSideImage.image.size.width)
        {
            CGPoint pointImg1 = CGPointMake(0,0);
            [self.leftSideImage.image drawAtPoint:pointImg1];
            
            CGPoint pointImg2 = CGPointMake((self.leftSideImage.image.size.width-self.rightSideImage.image.size.width)/2,self.leftSideImage.image.size.height);
            [self.rightSideImage.image drawAtPoint:pointImg2];
        }
        else
        {
            CGPoint pointImg1 = CGPointMake((self.rightSideImage.image.size.width-self.leftSideImage.image.size.width)/2,0);
            [self.leftSideImage.image drawAtPoint:pointImg1];
            
            CGPoint pointImg2 = CGPointMake(0,self.leftSideImage.image.size.height);
            [self.rightSideImage.image drawAtPoint:pointImg2];
        }
        
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        destination.finalImage = result;
        
        // *********************
    
    }
    else if ([segue.identifier isEqualToString:@"ImageView"])
    {
        ImageViewController * destination = segue.destinationViewController;
        destination.image = self.face;
        [destination.sliderLine setValue:self.sliderStatus];
    }
	else if ([segue.identifier isEqualToString:@"CameraView"])
	{
		CameraViewController *destination = segue.destinationViewController;
		destination.frontCameraActive = self.frontCamera;
	}
}


- (IBAction)acceptImage:(id)sender
{
    [self performSegueWithIdentifier:@"FinalImageView" sender:self];
}

- (IBAction)retakeImage:(id)sender
{
    [self performSegueWithIdentifier:@"CameraView" sender:self];
}

- (IBAction)editImage:(id)sender
{
    [self performSegueWithIdentifier:@"ImageView" sender:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
