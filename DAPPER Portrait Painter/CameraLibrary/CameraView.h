#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <math.h>

#import "FrameRectView.h"

@class CameraView;

@protocol CameraViewDelegate<NSObject>

@optional
- (void)captureEnded:(CameraView *)cameraView;
@end

@interface CameraView : UIView
<AVCaptureVideoDataOutputSampleBufferDelegate> {
@protected
    UIImage *imageBuffer;
    BOOL requireTakePhoto;
    BOOL processingTakePhoto;
    void *bitmap;
    
#ifndef __i386__
    AVCaptureSession *captureSession;
    dispatch_queue_t queue;
#endif
    
    UIImage *capturedImage;
    id delegate;
}

// Initializer
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

// Open camera session
- (void)openCameraSession;

// Close camera session
- (void)closeCameraSession;

// Do capture
- (void)doCapture;

// capture image
- (UIImage *)capturedImage;

// set frame mode
@property (nonatomic, assign) BOOL frameMode;
// set Front/Back Camera mode
@property (nonatomic, assign) BOOL isFront;

// set delegate
@property (nonatomic, assign) id delegate;

@end