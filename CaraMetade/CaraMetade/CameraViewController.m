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
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIView *frameForCapture;

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureInput *frontCamera;

@property (strong, nonatomic) AVCaptureInput *backCamera;

@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *referenceLine;

@end

@implementation CameraViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// Initialize AVCaptureSeesion and other objects needed.
	self.frontCameraActive = YES;
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
	
	self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
	[self.stillImageOutput setOutputSettings:outputSettings];
	
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	CALayer *rootLayer = [[self frameForCapture] layer];
	[rootLayer setMasksToBounds:YES];
	CGRect frame = self.view.frame;
	
	[previewLayer setFrame:frame];
	
	[rootLayer insertSublayer:previewLayer atIndex:0];
	
	[self.session addOutput:self.stillImageOutput];
	
	UIGraphicsBeginImageContext(CGSizeMake(3.0f, self.frameForCapture.frame.size.height));
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
	CGContextSetLineWidth(context, 4.0f);
	CGFloat dash[] = {10.0f , 5.0f};
	CGContextSetLineDash(context, 0, dash , 2);
	
	CGRect rect = CGRectMake(0, 0, 3.0f, self.frameForCapture.frame.size.height);
	
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	
	CGContextStrokePath(context);
	
	UIImage *line = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	self.referenceLine.image = line;
	
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    if ([self.session canAddInput:self.backCamera] && self.frontCameraActive == NO)
        [self.session addInput:self.backCamera];
	else if ([self.session canAddInput:self.backCamera])
		[self.session addInput:self.frontCamera];
        
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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
			
			ImageViewController * destination = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
			destination.image = self.image;
			destination.sliderStatus = 0.5;
			destination.cropperStatus = 0.5;
			destination.fromLibrary = NO;
			
			[self.session stopRunning];
			
			[self.navigationController pushViewController:destination animated:YES];
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



- (IBAction)pickFromPhotoLibrary:(id)sender
{
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}

#pragma mark - Double Tap

- (IBAction)doubleTap:(id)sender {
	[self cameraRotate:nil];
}

#pragma mark - Library

- (void) imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
    
    self.image = [UIImage imageWithCGImage:imageToUse.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    [self dismissViewControllerAnimated:YES completion:^{
		ImageViewController * destination = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
		destination.image = self.image;
		destination.sliderStatus = 0.5;
		destination.cropperStatus = 0.5;
		destination.fromLibrary = YES;
		
		[self.session stopRunning];
		
		[self.navigationController pushViewController:destination animated:YES];
    }];
}

#pragma mark - Face Detection

-(void)faceDetector
{
    // Load the picture for face detection
    UIImageView* image = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"faceDetection.jpg"]];
    
    // Draw the face detection image
    [self.view addSubview:image];
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:image];
    
    [image setTransform:CGAffineTransformMakeScale(1, -1)];
    
    [self.view setTransform:CGAffineTransformMakeScale(1, -1)];
    
    [self faceDetector];
}

-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracyHigh]];
    NSArray* features = [detector featuresInImage:image];
    for (CIFaceFeature* faceFeature in features) {
        
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        [self.view addSubview:faceView];
        
        if(faceFeature.hasLeftEyePosition)
        {
            
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            
            [self.view addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            
            [leftEye setCenter:faceFeature.rightEyePosition];
            
            leftEye.layer.cornerRadius = faceWidth*0.15;
            
            [self.view addSubview:leftEye];
        }
        
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [self.view addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            
            [leftEye setCenter:faceFeature.rightEyePosition];
            
            leftEye.layer.cornerRadius = faceWidth*0.15;
            
            [self.view addSubview:leftEye];
        }
        
    }
    
}

@end