//
//  ViewController.m
//  CaraMetade
//
//  Created by Lucas M. Juviniano on 23/03/15.
//  Copyright (c) 2015 Lucas M. Juviniano. All rights reserved.
//

#import "CameraViewController.h"
#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIView *frameForCapture;

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureInput *frontCamera;

@property (strong, nonatomic) AVCaptureInput *backCamera;

@property (strong, nonatomic) UIImage *image;

@end

@implementation CameraViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
	NSArray *devices = [AVCaptureDevice devices];
	AVCaptureDevice *front;
	AVCaptureDevice *back;
	
	for (AVCaptureDevice *device in devices)
		if ([device hasMediaType:AVMediaTypeVideo])
			{
			if ([device position] == AVCaptureDevicePositionBack)
				back = device;
			else if ([device position] == AVCaptureDevicePositionFront)
				front = device;
			}
    
    NSError *error;
	
	self.backCamera = [AVCaptureDeviceInput deviceInputWithDevice:back error:&error];
	self.frontCamera = [AVCaptureDeviceInput deviceInputWithDevice:front error:&error];
    
    if ([self.session canAddInput:self.backCamera] && self.frontCameraActive == NO)
        [self.session addInput:self.backCamera];
	else if ([self.session canAddInput:self.backCamera])
		[self.session addInput:self.frontCamera];

	
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self frameForCapture] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.view.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
        
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowImageView"])
	{
		ImageViewController * destination = segue.destinationViewController;
		destination.image = self.image;
		destination.frontCamera = self.frontCameraActive;
        destination.sliderStatus = 0.5;
        destination.cropperStatus = 0.5;
	}
}

#pragma mark - Camera Buttons

/// Takes a photo.
- (IBAction)takePhotto:(id)sender
{
	AVCaptureConnection *videoConnection = nil;
	
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo])
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection)
		{
			break;
		}
	}
	
	if (videoConnection.supportsVideoOrientation)
		videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
	
//	self.stillImageOutput.automaticallyEnablesStillImageStabilizationWhenAvailable = YES;
	
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSamplerBuffer, NSError *error) {
		if (imageDataSamplerBuffer != NULL)
		{
			NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSamplerBuffer];
			self.image = [[UIImage alloc] initWithData:imageData];
            
			[self performSegueWithIdentifier:@"ShowImageView" sender:self];
		}
	}];
	
}

/// Rotate the camera.
- (IBAction)cameraRotate:(id)sender {
	if (self.session.inputs[0] == self.backCamera)
	{
		[self.session removeInput:self.backCamera];
		[self.session addInput:self.frontCamera];
		self.frontCameraActive = YES;
	}
	else
	{
		[self.session removeInput:self.frontCamera];
		[self.session addInput:self.backCamera];
		self.frontCameraActive = NO;
	}
}

@end