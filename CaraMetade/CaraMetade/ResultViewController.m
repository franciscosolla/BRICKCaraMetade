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
	// Loads the image on the ImageView..
	self.leftSideImage.image = self.face;
	self.rightSideImage.image = self.face;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
