#import "CameraView.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

// rotation angle
typedef enum RotationAngle_ {
    RotationAngle90 = 90,
    RotationAngle180 = 180,
    RotationAngle270 = 270,
} RotationAngle;

@interface CameraView ()

- (UIImage *)rotateImage:(UIImage *)img angle:(RotationAngle)angle;
- (void)callCaptureEnded;

@property (nonatomic, retain) FrameRectView *frameRectView;

@property (assign, readonly) size_t cameraWidth;
@property (assign, readonly) size_t cameraHeight;
@property (readonly) NSString * cameraSessionPreset;
@property (nonatomic, retain) UIImage *imageBuffer;
@property (retain) UIImage *capturedImage;

#ifndef __i386__
@property (nonatomic, retain) AVCaptureSession *captureSession;
#endif

@end

@implementation CameraView

#pragma mark -
#pragma mark public methods

- (id)initWithFrame:(CGRect)frame delegate:(id)adelegate {
    self = [super initWithFrame:frame];
    [self setDelegate:adelegate];
    
    // set frame rect view
    {
        FrameRectView *frView = [[FrameRectView alloc] initWithFrame:frame
                                                         withCenterY:self.frame.size.height / 2];
        [frView autorelease];
        [self setFrameRectView:frView];
        [self addSubview:frView];
    }
    
    return self;
}

- (void)openCameraSession {
    requireTakePhoto = NO;
    processingTakePhoto = NO;
    
    // Initialize image buffer
    // ---------
	size_t width = self.cameraWidth;
	size_t height = self.cameraHeight;
    
	bitmap = NSZoneMalloc(self.zone, width * height * 4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, bitmap, width * height * 4, NULL);
	CGImageRef cgImage = CGImageCreate(width, height, 8, 32, width * 4,
                                       colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst,
                                       dataProviderRef, NULL, 0, kCGRenderingIntentDefault);
	self.imageBuffer = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(dataProviderRef);
    // ---------
    
#ifndef __i386__
    
	// Start session open
	self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
    
    // Select device
    AVCaptureDevice *videoCaptureDevice = nil;
	NSArray *cameraArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *camera in cameraArray) {
        if (self.isFront) {
            if (camera.position == AVCaptureDevicePositionFront) {
                videoCaptureDevice = camera;
            }
        } else {
            if (camera.position == AVCaptureDevicePositionBack) {
                videoCaptureDevice = camera;
            }
        }
	}
    
	// Set video stream
    // ---------
	NSError *error = nil;
	AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
	if (videoInput) {
		[self.captureSession addInput:videoInput];
        
		// config (session)
		[self.captureSession beginConfiguration];
		self.captureSession.sessionPreset = self.cameraSessionPreset;
		[self.captureSession commitConfiguration];
		
        // config (input)
        // -- set video mode
		if ([videoCaptureDevice lockForConfiguration:&error]) {
            
            // AVMode -> AutoFocus
			if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
				videoCaptureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
			}else {
				if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
					videoCaptureDevice.focusMode = AVCaptureFocusModeAutoFocus;
				}
			}
            
            // Flash -> auto mode
			if ([videoCaptureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
				videoCaptureDevice.flashMode = AVCaptureFlashModeAuto;
			}
            
            // Exposure -> auto exposure
			if ([videoCaptureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
				videoCaptureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
			}
            
            // White balance -> auto white balance
			if ([videoCaptureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
				videoCaptureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;			}
            
            // torch mode -> off
			if ([videoCaptureDevice isTorchModeSupported:AVCaptureTorchModeOff]){
				videoCaptureDevice.torchMode = AVCaptureTorchModeOff;
			}
            
			[videoCaptureDevice unlockForConfiguration];
            
		}else {
			NSLog(@"ERROR:%@", error);
		}
        // ---------
        
		// Get preview layer and set self layer.
        // ---------
		AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
		previewLayer.automaticallyAdjustsMirroring = NO;
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;	// ぴっちり全面
		previewLayer.frame = self.bounds;
		[self.layer insertSublayer:previewLayer atIndex:0];
        // ---------
        
	}else {
		NSLog(@"ERROR:%@", error);
	}
    
    // Get video data  (Code Snippet SP16)
    // ---------
	AVCaptureVideoDataOutput *videoOutput = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
	if(videoInput){
		videoOutput.videoSettings = [NSDictionary dictionaryWithObject:
                                     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//		videoOutput.minFrameDuration = CMTimeMake(1, 20);	// 20fps
		videoOutput.alwaysDiscardsLateVideoFrames = YES;
		queue = dispatch_queue_create("jp.mmasashi.camera.CameraView", NULL);
		[videoOutput setSampleBufferDelegate:self queue:queue];
		dispatch_release(queue);
		[self.captureSession addOutput:videoOutput];
	}
    // ---------
    
	// Start video session
	if(videoInput){
		[self.captureSession startRunning];
	}
#endif
}

- (void)closeCameraSession {
#ifndef __i386__
	[self.captureSession stopRunning];
	for (AVCaptureOutput *output in self.captureSession.outputs) {
		[self.captureSession removeOutput:output];
	}
	for (AVCaptureInput *input in self.captureSession.inputs) {
		[self.captureSession removeInput:input];
	}
	self.captureSession = nil;
#endif
	NSZoneFree(self.zone, bitmap);
	bitmap = NULL;
}

- (void)doCapture {
    if (!processingTakePhoto) {
        requireTakePhoto = YES;
    }
}

#pragma mark -
#pragma mark camera parameter

- (size_t)cameraWidth {
  return 640;
}
- (size_t)cameraHeight {
  return 480;
}
- (NSString *)cameraSessionPreset {
  return AVCaptureSessionPreset640x480;
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

#ifndef __i386__
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
	if (requireTakePhoto) {
		requireTakePhoto = NO;
		processingTakePhoto = YES;
		CVPixelBufferRef pixbuff = CMSampleBufferGetImageBuffer(sampleBuffer);
		if(CVPixelBufferLockBaseAddress(pixbuff, 0) == kCVReturnSuccess){
            
			memcpy(bitmap, CVPixelBufferGetBaseAddress(pixbuff), self.cameraWidth * self.cameraHeight * 4);
            
            // Rotate image
            UIImage *rotatedImage = [self rotateImage:self.imageBuffer angle:RotationAngle270];
            
            UIImage *capImage = rotatedImage;
           
            {
/*
//                CGRect stRect = self.frame;
                
                // Get scale rate
//                CGFloat rateW = 1.0f * self.cameraHeight / self.frame.size.width;
//                CGFloat rateH = 1.0f * self.cameraWidth / self.frame.size.height;
//                CGFloat rateAll = (rateW < rateH) ? rateW : rateH;
//                
//                // Crop image
//                CGFloat hiddenWidth = (self.frame.size.height / self.cameraWidth) * self.cameraHeight - self.frame.size.width;
//                CGFloat hiddenHeight = (self.frame.size.width / self.cameraHeight) * self.cameraWidth - self.frame.size.height;
//                
//                hiddenWidth = (hiddenWidth < 0) ? 0 : hiddenWidth;
//                hiddenHeight = (hiddenHeight < 0) ? 0 : hiddenHeight;
                
//                CGRect cropRect = CGRectMake(stRect.origin.x * rateAll + hiddenWidth * rateAll/2,
//                                             stRect.origin.y * rateAll + hiddenHeight * rateAll/2,
//                                             stRect.size.width * rateAll,
//                                             stRect.size.height * rateAll);
                
                CGRect cropRect = CGRectMake((capImage.size.width - self.frame.size.width) / 2,
                                             (capImage.size.height - self.frame.size.height) / 2,
                                             self.frame.size.width, self.frame.size.height);
                
                CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, cropRect);
                capImage = [UIImage imageWithCGImage:croppedImage];
                
                NSLog(@"width = %f, height = %f", capImage.size.width, capImage.size.height);
                
                CGImageRelease(croppedImage);
*/ 
            }
            
            if ([self frameMode]) {
                CGRect stRect = self.frameRectView.targetFrameRect;
                
                // Get scale rate
                CGFloat rateW = 1.0f * self.cameraHeight / self.frame.size.width;
                CGFloat rateH = 1.0f * self.cameraWidth / self.frame.size.height;
                CGFloat rateAll = (rateW < rateH) ? rateW : rateH;
                
                // Crop image
                CGFloat hiddenWidth = (self.frame.size.height / self.cameraWidth) * self.cameraHeight - self.frame.size.width;
                CGFloat hiddenHeight = (self.frame.size.width / self.cameraHeight) * self.cameraWidth - self.frame.size.height;
                
                hiddenWidth = (hiddenWidth < 0) ? 0 : hiddenWidth;
                hiddenHeight = (hiddenHeight < 0) ? 0 : hiddenHeight;
                
                CGRect cropRect = CGRectMake(stRect.origin.x * rateAll + hiddenWidth * rateAll/2,
                                             stRect.origin.y * rateAll + hiddenHeight * rateAll/2,
                                             stRect.size.width * rateAll,
                                             stRect.size.height * rateAll);
                
                CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, cropRect);
                capImage = [UIImage imageWithCGImage:croppedImage];
                
                NSLog(@"width = %f, height = %f", capImage.size.width, capImage.size.height);
                
                CGImageRelease(croppedImage);
            }
            
            [self performSelectorOnMainThread:@selector(endedCaptureCameraImage:)
                                   withObject:capImage
                                waitUntilDone:NO];
            
			CVPixelBufferUnlockBaseAddress(pixbuff, 0);
		}
	}
}
#endif


- (void)endedCaptureCameraImage:(UIImage *)uiimage {
    
    processingTakePhoto = NO;
    [self setCapturedImage:uiimage];
    [self callCaptureEnded];
}

#pragma mark - frame mode

- (void)setFrameMode:(BOOL)frameMode {
    if (frameMode) {
        [self.frameRectView setHidden:NO];
    } else {
        [self.frameRectView setHidden:YES];
    }
}

- (BOOL)frameMode {
    return [self.frameRectView isHidden] ? NO : YES;
}

#pragma mark -
#pragma delegate methods

- (void)callCaptureEnded {
    NSLog(@"IN %s", __func__);
    if ([delegate respondsToSelector:@selector(captureEnded:)]) {
        [delegate performSelector:@selector(captureEnded:) withObject:self];
    }
    
}

#pragma mark -
#pragma utlity methods

// rotate image
- (UIImage *) rotateImage:(UIImage *)img angle:(RotationAngle)angle
{
    CGImageRef imgRef = [img CGImage];
    CGContextRef context;
    
    switch (angle) {
        case RotationAngle90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case RotationAngle180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case RotationAngle270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            NSLog(@"you can select an angle of 90, 180, 270");
            return nil;
    } 
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext(); 
    
    UIGraphicsEndImageContext();
    return ret;
}

#pragma mark -

- (void)dealloc {
    self.imageBuffer = nil;
    self.capturedImage = nil;
#ifndef __i386__
	self.captureSession = nil;
#endif
    
    [self setFrameRectView:nil];
    [super dealloc];
}

@synthesize imageBuffer;
@synthesize capturedImage;

#ifndef __i386__
@synthesize captureSession;
#endif

@synthesize delegate;

@synthesize frameRectView;

@end
