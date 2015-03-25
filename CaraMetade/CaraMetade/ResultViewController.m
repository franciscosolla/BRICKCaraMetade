//
//  ResultViewController.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 25/03/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController()

@property (weak, nonatomic) IBOutlet UIImageView *leftSideImage;

@property (weak, nonatomic) IBOutlet UIImageView *rightSideImage;

@end

@implementation ResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	// Loads the image ad splits in half and displays in right and left view.
	CGImageRef leftImage = CGImageCreateWithImageInRect(self.face.CGImage, CGRectMake(0, 0, self.face.size.height, (self.face.size.width * [self.sliderStatus doubleValue])));
	CGImageRef rightImage = CGImageCreateWithImageInRect(self.face.CGImage, CGRectMake(0, (self.face.size.width * [self.sliderStatus doubleValue]), self.face.size.height, (self.face.size.width * (1.0f - [self.sliderStatus doubleValue]))));
    
    self.leftSideImage.image = [UIImage imageWithCGImage:leftImage scale:1 orientation:self.face.imageOrientation];
	self.rightSideImage.image = [UIImage imageWithCGImage:rightImage scale:1 orientation:self.face.imageOrientation];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
