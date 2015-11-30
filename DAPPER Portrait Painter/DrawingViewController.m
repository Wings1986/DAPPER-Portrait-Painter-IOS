//
//  DrawingViewController.m
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import "DrawingViewController.h"

#import "OptionViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

#import "Global.h"
#import "ColorImageView.h"
#import "UIImage+Grayscale.h"
#import "ZDStickerView.h"

#import "NXMaskEngine.h"
#import <QuartzCore/QuartzCore.h>
#import "CCColorCube.h"
#import "CCImageColors.h"

#import "GPUImage.h"


typedef enum {
    BODY_1,
    BODY_2,
    WALL_1,
    WALL_2,
    FACE_1,
    FACE_2,
    FACE_3,
    FACE_4
}COLOR_TYPE;

typedef enum {
    BRUSH_SMALL = 10,
    BRUSH_MIDDLE = 15,
    BRUSH_BIG = 20
}BRUSH_TYPE;

typedef enum
{
    DRAWER,
    ERASER
}DRAW_TOOL;

#define TAG_ASSERT_VIEW     1000


@interface DrawingViewController ()<UIScrollViewDelegate, ZDStickerViewDelegate>
{
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIView *contentContainerView;
    
    IBOutlet UIImageView *mCanvasView;
    IBOutlet UIImageView *mMaskView;
    IBOutlet UIImageView *mFrameView;
    
    IBOutlet UIView *mPaintBoardView;
    
    IBOutlet ColorImageView *mPaintColor1;
    IBOutlet ColorImageView *mPaintColor2;
    IBOutlet ColorImageView *mPaintColor3;
    IBOutlet ColorImageView *mPaintColor4;
    IBOutlet ColorImageView *mPaintColor5;
    IBOutlet ColorImageView *mPaintColor6;
    IBOutlet ColorImageView *mPaintColor7;
    IBOutlet ColorImageView *mPaintColor8;
    IBOutlet ColorImageView *mPaintColorSelect;
    
    
    IBOutlet UITextField *lbTitle;
    
    IBOutlet UIImageView *brushSmallView;
    IBOutlet UIImageView *brushMiddleView;
    IBOutlet UIImageView *brushBigView;
    
    IBOutlet UIButton *btnPan;
    
    COLOR_TYPE m_ColorType;
    DRAW_TOOL m_DrawTool;
    BRUSH_TYPE m_BrushType;
    
    CGPoint previousPoint;
    CGFloat imageDisplayScale;
    
    UIPanGestureRecognizer * panGestureRecognizer;
    BOOL    m_bPan;
    float   m_scale;
    
    
    GPUImageSmoothToonFilter * selectedFilter;

    
    IBOutlet NSLayoutConstraint *constraintHeightTop;
    IBOutlet NSLayoutConstraint *constraintHeightBottom;
}

@property (strong, nonatomic) CCColorCube *colorCube;

@end


@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _colorCube = [[CCColorCube alloc] init];
    
    UIImage * maskedFace = [UIImage maskImage:_originImg withMask:[UIImage imageNamed:@"mask_head_reverse.png"]];
    UIImage * maskedBody = [UIImage maskImage:_originImg withMask:[UIImage imageNamed:@"mask_body_reverse.png"]];
    UIImage * maskedWall = [UIImage maskImage:_originImg withMask:[UIImage imageNamed:@"mask_outline_reverse.png"]];
    
//    UIImageView* s = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
//    s.image = maskedFace;
//    [self.view addSubview:s];
//
//    s = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 150)];
//    s.image = maskedBody;
//    [self.view addSubview:s];
//
//    s = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0, 100, 150)];
//    s.image = maskedWall;
//    [self.view addSubview:s];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        int mode = 1;
        // White (need to create with RGB components. [UIColor whiteColor] returns two component color (gray intensity & alpha)).
        UIColor *rgbWhite = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        UIColor *rgbBlue  = [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1];

        CCImageColors * imageColorsFace;
        CCImageColors * imageColorsBody;
        CCImageColors * imageColorsWall;
        
        // face detect
        {
            // Extract colors (try to get four distinct)
            NSArray *extractedColors = nil;
            
            // Extract colors (try to get four distinct)
            switch (mode) {
                case 0:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedFace avoidColor:nil count:4];
                    break;
                case 1:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedFace avoidColor:rgbWhite count:4];
                    break;
                case 2:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedFace avoidColor:rgbBlue count:4];
                    break;
            }
            imageColorsFace = [[CCImageColors alloc] initWithExtractedColors:extractedColors];
        }
        
        // body detect
        {
            // Extract colors (try to get four distinct)
            NSArray *extractedColors = nil;
            
            // Extract colors (try to get four distinct)
            switch (mode) {
                case 0:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedBody avoidColor:nil count:2];
                    break;
                case 1:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedBody avoidColor:rgbWhite count:2];
                    break;
                case 2:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedBody avoidColor:rgbBlue count:2];
                    break;
            }
            imageColorsBody = [[CCImageColors alloc] initWithExtractedColors:extractedColors];
        }

        // wall detect
        {
            // Extract colors (try to get four distinct)
            NSArray *extractedColors = nil;
            
            // Extract colors (try to get four distinct)
            switch (mode) {
                case 0:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedWall avoidColor:nil count:2];
                    break;
                case 1:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedWall avoidColor:rgbWhite count:2];
                    break;
                case 2:
                    extractedColors = [_colorCube extractBrightColorsFromImage:maskedWall avoidColor:rgbBlue count:2];
                    break;
            }
            imageColorsWall = [[CCImageColors alloc] initWithExtractedColors:extractedColors];
        }

        // Set new color array on main thread and refresh table view
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [mPaintColor1 setMaskColor:imageColorsBody.color1];
            [mPaintColor2 setMaskColor:imageColorsBody.color2];
            [mPaintColor3 setMaskColor:imageColorsWall.color1];
            [mPaintColor4 setMaskColor:imageColorsWall.color2];
            [mPaintColor5 setMaskColor:imageColorsFace.color1];
            [mPaintColor6 setMaskColor:imageColorsFace.color2];
            [mPaintColor7 setMaskColor:imageColorsFace.color3];
            [mPaintColor8 setMaskColor:imageColorsFace.color4];
            m_ColorType = FACE_1;
            [self setPaintColor];
            
            
        });
    });

    
    [mPaintColor1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor7 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColor8 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    [mPaintColorSelect addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPaintColor:)]];
    
    
    m_DrawTool = DRAWER;
    m_BrushType = BRUSH_BIG;
    [self refreshBrush];
    [brushSmallView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBrush:)]];
    [brushMiddleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBrush:)]];
    [brushBigView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBrush:)]];
    
    
//    // 1 step
//    selectedFilter = [[GPUImageSmoothToonFilter alloc] init];
//    selectedFilter.threshold = 0.9;
//    selectedFilter.quantizationLevels = 20;
//    UIImage *cartoonImage = [selectedFilter imageByFilteringImage:_originImg];
//    s.image = cartoonImage;
//    
//    // 2 step
//    UIImage *grayscaleImg = [cartoonImage convertToGrayscale];

    // get Brightness
    NXMaskEngine *maskEngine = [NXMaskEngine sharedEngine];
    maskEngine.arrayBrightness = [self analyseBrightness:_originImg];
    
    
    
    // 1 step
    UIImage *grayscaleImg = [_originImg convertToGrayscale];

    // 2 step
    selectedFilter = [[GPUImageSmoothToonFilter alloc] init];
    selectedFilter.threshold = 0.9;
    selectedFilter.quantizationLevels = 15;
    UIImage *cartoonImage = [selectedFilter imageByFilteringImage:grayscaleImg];
//    s.image = cartoonImage;
    

    
    // init Mask
    
//    NXMaskEngine *maskEngine = [NXMaskEngine sharedEngine];
    [maskEngine setMyOriginalImage:cartoonImage];
    
    NXMaskDrawContext ctx = [maskEngine createDrawContext];
//    [maskEngine drawInitMaskLine:m_BrushType inContext:ctx RECT:mMaskView.frame];
    [maskEngine drawInitMask:m_BrushType inContext:ctx];

    [mMaskView.layer setMagnificationFilter:kCAFilterTrilinear];
    
//    mMaskView.image = maskEngine.displayableMaskImage;
    
    
    mCanvasView.image = maskEngine.originalImage;
    mMaskView.image = maskEngine.displayableMaskImage;
    
    [self resetPaintGesture];

    NSLog(@"image = > view width = %f, height = %f", maskEngine.displayableMaskImage.size.width, maskEngine.displayableMaskImage.size.height);
    
    NSLog(@"loadView = > view width = %f, height = %f", mCanvasView.frame.size.width, mCanvasView.frame.size.height);

    
    float viewHeight = mCanvasView.frame.size.width * maskEngine.displayableMaskImage.size.height / maskEngine.displayableMaskImage.size.width;
    
    float offset = (self.view.frame.size.height - viewHeight) / 2;
    NSLog(@"offset = %f", offset);
    
    constraintHeightBottom.constant = constraintHeightTop.constant = offset;
    
    
    m_scale = 1.0f;
    contentScrollView.minimumZoomScale = 1.0f;
    contentScrollView.maximumZoomScale = MAX_ZOOM_SCALE;
//    if (imageDisplayScale > MAX_ZOOM_SCALE)
//        contentScrollView.maximumZoomScale = imageDisplayScale;
    contentScrollView.zoomScale = m_scale;
    contentScrollView.contentOffset = CGPointMake(0, 0);

    lbTitle.text = @"";
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [contentContainerView addGestureRecognizer:doubleTap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    NXMaskEngine *maskEngine = [NXMaskEngine sharedEngine];

    CGFloat scaleX = maskEngine.originalImage.size.width / mMaskView.frame.size.width;
    CGFloat scaleY = maskEngine.originalImage.size.height / mMaskView.frame.size.height;
    if (scaleX > scaleY)
        imageDisplayScale = scaleY;
    else
        imageDisplayScale = scaleX;
    imageDisplayScale = scaleX;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"gotoOption"]) {
         OptionViewController * vc = segue.destinationViewController;
         vc.name = lbTitle.text;
         vc.captureImage = [self getCaptureImage:lbTitle.text];
         vc.drawingViewController = self;
     }
 }

- (NSMutableArray*) analyseBrightness:(UIImage*) img
{
    NSMutableArray * arrayBrightness = [[NSMutableArray alloc] init];
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int width = img.size.width;
    int height = img.size.height;
    
    for (int x = 0 ; x < width; x ++) {
        
        NSMutableArray * sub = [[NSMutableArray alloc] init];
        
        for (int y = 0; y < height; y ++) {
            int pixelInfo = ((width  * y) + x ) * 4;
            
            UInt8 red = data[pixelInfo];
            UInt8 green = data[(pixelInfo + 1)];
            UInt8 blue = data[pixelInfo + 2];
//            UInt8 alpha = data[pixelInfo + 3];
            
//            UIColor *color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
//            
//            CGFloat hue;
//            CGFloat saturation;
//            CGFloat brightness;
//            CGFloat falpha;
//            BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&falpha];
            
            
            int brightness = (red + green + blue) * 10 / (255 * 3);
            
            if (YES) {
                
                [sub addObject:[NSNumber numberWithInt:brightness]];
                
            }
            
        }
        
        [arrayBrightness addObject:sub];
    }
    
    CFRelease(pixelData);
    
    return arrayBrightness;
}

/*
- (float) getBrightness:(int) x y : (int) y
{
    if (arrayBrightness != nil) {
        
        if (arrayBrightness.count <= x) {
            return 0;
        }
        if (((NSArray*)arrayBrightness[x]).count <= y) {
            return 0;
        }
        
        int brightness = [arrayBrightness[x][y] intValue];
        
        float opacity = 1.0f;
        
        switch (brightness) {
            case 0:
            case 1:
                opacity = 0.1;
                break;
            case 2:
                opacity = 0.14;
                break;
            case 3:
                opacity = 0.19;
                break;
            case 4:
                opacity = 0.23;
                break;
            case 5:
                opacity = 0.28;
                break;
            case 6:
                opacity = 0.32;
                break;
            case 7:
                opacity = 0.37;
                break;
            case 8:
                opacity = 0.41;
                break;
            case 9:
                opacity = 0.46;
                break;
            case 10:
                opacity = 0.5;
                break;
        }
        
        NSLog(@"opacity = %f", opacity);
        
        return opacity;
    }
    
    return 1;
}
*/

- (UIImage *) getCaptureImage:(NSString*) text
{
    if (text != nil) {
        lbTitle.text = text;
    }
    
    return [UIImage imageWithView:contentContainerView];
}

- (void) resetPaintGesture
{
    m_bPan = NO;
    [self addGesture];
    
    btnPan.selected = m_bPan;
}
- (void) addGesture
{
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanDrawing:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
    }
    [contentScrollView addGestureRecognizer:panGestureRecognizer];
    
    contentScrollView.delegate = nil;
}
-(void) removeGestrue
{
    if (panGestureRecognizer != nil) {
        [contentScrollView removeGestureRecognizer:panGestureRecognizer];
    }
    contentScrollView.delegate = self;
}
- (void) showGestureAssert
{
    if (panGestureRecognizer != nil) {
        [contentScrollView removeGestureRecognizer:panGestureRecognizer];
    }
}
- (void) hideGestureAssert {
    if (contentScrollView.delegate == nil) {
        [self addGesture];
    }
}

- (IBAction)onTapPan:(id)sender {

    m_bPan = !m_bPan;
    
    if (m_bPan) {
        [self removeGestrue];
    } else {
        [self addGesture];
    }
    
    btnPan.selected = m_bPan;
}

- (IBAction)onTapEraser:(id)sender {
    m_DrawTool = ERASER;
    
    [self resetPaintGesture];
}

- (void) onTapPaintColor:(UIGestureRecognizer*) gesture
{
    m_DrawTool = DRAWER;
    
    ColorImageView * imgView = (ColorImageView*) gesture.view;
    
    if (imgView == mPaintColor1) {
        m_ColorType = BODY_1;
    }
    if (imgView == mPaintColor2) {
        m_ColorType = BODY_2;
    }
    if (imgView == mPaintColor3) {
        m_ColorType = WALL_1;
    }
    if (imgView == mPaintColor4) {
        m_ColorType = WALL_2;
    }
    if (imgView == mPaintColor5) {
        m_ColorType = FACE_1;
    }
    if (imgView == mPaintColor6) {
        m_ColorType = FACE_2;
    }
    if (imgView == mPaintColor7) {
        m_ColorType = FACE_3;
    }
    if (imgView == mPaintColor8) {
        m_ColorType = FACE_4;
    }
    
    [self setPaintColor];
    
    [self resetPaintGesture];
}
- (void) setPaintColor
{
    UIColor * color;
    UIColor * alphaColor;
    if (m_ColorType == BODY_1) {
        color = mPaintColor1.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.1];
    }
    else if (m_ColorType == BODY_2) {
        color = mPaintColor2.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.1];
    }
    else if (m_ColorType == WALL_1) {
        color = mPaintColor3.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.25];
    }
    else if (m_ColorType == WALL_2) {
        color = mPaintColor4.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.25];
    }
    else if (m_ColorType == FACE_1) {
        color = mPaintColor5.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.4];
    }
    else if (m_ColorType == FACE_2) {
        color = mPaintColor6.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.4];
    }
    else if (m_ColorType == FACE_3) {
        color = mPaintColor7.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.5];
    }
    else if (m_ColorType == FACE_4) {
        color = mPaintColor8.mMaskColor;
        alphaColor = [color colorWithAlphaComponent:0.5];
    }
    
    [mPaintColorSelect setMaskColor:color];
    
    NXMaskEngine *maskEngine = [NXMaskEngine sharedEngine];
//    maskEngine.displayableMaskColor = alphaColor;
    maskEngine.displayableMaskColor = color;
    
}

- (void) onTapBrush:(UIGestureRecognizer*) gesture
{
    ColorImageView * imgView = (ColorImageView*) gesture.view;
    
    if (imgView == brushSmallView) {
        m_BrushType = BRUSH_SMALL;
    }
    else if (imgView == brushMiddleView) {
        m_BrushType = BRUSH_MIDDLE;
    }
    else if (imgView == brushBigView) {
        m_BrushType = BRUSH_BIG;
    }

    [self refreshBrush];
    
    [self resetPaintGesture];
}

- (void) refreshBrush
{
    [brushSmallView setImage:[UIImage imageNamed:@"pen_1.png"]];
    [brushMiddleView setImage:[UIImage imageNamed:@"pen_2.png"]];
    [brushBigView setImage:[UIImage imageNamed:@"pen_3.png"]];
    
    if (m_BrushType == BRUSH_BIG) {
        [brushBigView setImage:[UIImage imageNamed:@"pen_3_sel.png"]];
    }
    else if (m_BrushType == BRUSH_MIDDLE) {
        [brushMiddleView setImage:[UIImage imageNamed:@"pen_2_sel.png"]];
    }
    else if (m_BrushType == BRUSH_SMALL) {
        [brushSmallView setImage:[UIImage imageNamed:@"pen_1_sel.png"]];
    }
    
}

#pragma mark - Drawing
- (void)onPanDrawing:(UIPanGestureRecognizer *)sender
{
   
    if (m_bPan) {
        return;
    }
    
    static BOOL isDrawing = NO;
    static NXMaskDrawContext ctx = nil;
    
    NXMaskEngine *maskEngine = [NXMaskEngine sharedEngine];
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        isDrawing = YES;
        previousPoint = [sender locationInView:mMaskView];
        previousPoint.x = previousPoint.x * imageDisplayScale;
        previousPoint.y = previousPoint.y * imageDisplayScale;
        
//        NSLog(@"drawing mask : x = %f, y = %f", previousPoint.x, previousPoint.y);
//        
//        CGPoint frame = [sender locationInView:mFrameView];
//        NSLog(@"frame mask : x = %f, y = %f", frame.x, frame.y);
        
        if (m_DrawTool == DRAWER)
        {
            ctx = [maskEngine createDrawContext];
            [maskEngine saveMaskLineFirstPoint:previousPoint inContext:ctx];
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (isDrawing)
        {
            CGPoint currPoint = [sender locationInView:mMaskView];
            currPoint.x = currPoint.x * imageDisplayScale;
            currPoint.y = currPoint.y * imageDisplayScale;

            
            if (m_DrawTool == DRAWER)
            {
                [maskEngine drawMaskLineSegmentTo:currPoint withMaskWidth:m_BrushType/m_scale inContext:ctx];
                mMaskView.image = maskEngine.displayableMaskImage;
//                mMaskView.image = maskEngine.maskImage;
//                maskAppliedImageView.image = [maskEngine maskAppliedImage];
            }
            else if (m_DrawTool == ERASER)
            {
                [maskEngine eraseMaskLineSegmentFrom:previousPoint to:currPoint withMaskWidth:m_BrushType/m_scale];
                mMaskView.image = maskEngine.displayableMaskImage;
//                maskAppliedImageView.image = [maskEngine maskAppliedImage];
            }
            previousPoint = currPoint;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded ||
             sender.state == UIGestureRecognizerStateCancelled)
    {
        if (isDrawing)
        {
            isDrawing = NO;
            if (m_DrawTool == DRAWER)
            {
                [maskEngine finalizeDrawContext:ctx withMaskWidth:m_BrushType/m_scale];
                mMaskView.image = maskEngine.displayableMaskImage;
//                mMaskView.image = maskEngine.maskImage;
//                maskAppliedImageView.image = [maskEngine maskAppliedImage];
//                testView.frame = [maskEngine maskExtentRect];
            }
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentContainerView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    m_scale = scale;
}


- (void) doubleTap:(UIGestureRecognizer*) gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
        
        for (UIView *subview in ((UIView*) gesture.view).subviews) {
            
            // List the subviews of subview
            
            if ([subview isKindOfClass:[ZDStickerView class]]) {
                
                CGPoint point = [gesture locationInView:contentContainerView];
                
                if (CGRectContainsPoint(subview.frame, point)) {
                    
                    ZDStickerView * sticker = (ZDStickerView*)subview;
                    
                    [sticker showEditingHandles];
                    [sticker showGesture];
                    
                    [sticker removeFromSuperview];
                    [contentContainerView addSubview:sticker];
                    
                    
                    [self showGestureAssert];
                    
                    break;
                }
            }
            
        }
    }
    else if (gesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture


        
    }
   
}

#pragma mark - set assert
- (void) setAssert:(NSDictionary*) assert title:(NSString*) name
{
    _dicAssert = assert;
    
    if (_dicAssert != nil) {
        NSString *imageName = [NSString stringWithFormat:@"%@.png", _dicAssert[@"img"]];
        UIImage * image = [UIImage imageNamed:imageName];
        NSInteger tag = [_dicAssert[@"tag"] integerValue];
        
        if (tag == 0) { // frame
            mFrameView.image = image;
        }
        else {
            ZDStickerView* assertView = (ZDStickerView*)[contentContainerView viewWithTag:TAG_ASSERT_VIEW+tag];
            if (assertView == nil) {
                int width = image.size.width > contentContainerView.frame.size.width/2 ? contentContainerView.frame.size.width/2 : image.size.width;
                int height = image.size.height / image.size.width * width;
                
                UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                [contentView setBackgroundColor:[UIColor clearColor]];
                UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                imageView.tag = 2000;
                [contentView addSubview: imageView];
                
                assertView = [[ZDStickerView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                assertView.center = contentContainerView.center;
                assertView.tag = TAG_ASSERT_VIEW + tag;
                assertView.delegate = self;
                assertView.contentView = contentView;//contentView;
                assertView.preventsPositionOutsideSuperview = NO;
                [assertView showEditingHandles];
                
                [assertView setButton:ZDSTICKERVIEW_BUTTON_DONE image:[UIImage imageNamed:@"button_done.png"]];
                [contentContainerView addSubview:assertView ];
                
            }
            else {
                UIImageView *imgView = (UIImageView*) [assertView.contentView viewWithTag:2000];
                imgView.image = image;
                
                
                [assertView showEditingHandles];
                [assertView showGesture];

                [assertView removeFromSuperview];
                [contentContainerView addSubview:assertView];
            }
            
            [self showGestureAssert];
        }
        
    }
    
    if (name != nil) {
        lbTitle.text = name;
    }
}

- (void) onNewPortrait
{
//    [self.navigationController popToViewController:((AppDelegate*)[UIApplication sharedApplication].delegate).m_HomeViewController animated:NO];
//    [self performSegueWithIdentifier:@"gotoHome" sender:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    HomeViewController * vc = (HomeViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:vc animated:YES completion:^{}];
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark SDStickerView Delegate
- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    [sticker removeFromSuperview];
    [contentContainerView insertSubview:sticker aboveSubview:mMaskView];
    
    [self hideGestureAssert];
}

@end
