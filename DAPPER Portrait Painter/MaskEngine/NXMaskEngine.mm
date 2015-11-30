//
//  NXMaskEngine.m
//  LeafMask
//
//  Created by osone on 3/21/13.
//  Copyright (c) 2013 TEX Soft. All rights reserved.
//

#import "NXMaskEngine.h"
#import "NXImageUtils.h"
#import "GPUImage.h"
#import <CoreImage/CoreImage.h>

#define MAGNET_DRAW_WIDTH       60
#define MAX_PROCESS_WIDTH       250

@interface NXMaskEngine ()


@end

@implementation NXMaskEngine

+ (NXMaskEngine *)sharedEngine
{
    static NXMaskEngine *engine = nil;
    if (engine == nil)
        engine = [[NXMaskEngine alloc] init];
    return engine;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.originalImage = nil;
        self.maskImage = nil;
        self.displayableMaskImage = nil;
        self.drawingmage = nil;
        self.displayableMaskColor = [UIColor redColor];
    }
    
    return self;
}

- (NXMaskDrawContext)createDrawContext
{
    NXMaskDrawContext newContext = [NSMutableArray array];
    return newContext;
}

- (void)finalizeDrawContext:(NXMaskDrawContext)context withMaskWidth:(CGFloat)maskWidth
{
    if (context == nil || context.count == 0)
        return;
}

- (void)saveMaskLineFirstPoint:(CGPoint)pt inContext:(NXMaskDrawContext)context
{
    if (context == nil)
        return;
    [context removeAllObjects];
    [context addObject:[NSValue valueWithCGPoint:pt]];
    
}

- (void)drawMaskLineSegmentTo:(CGPoint)ptTo withMaskWidth:(CGFloat)maskWidth inContext:(NXMaskDrawContext)context
{
    if (context == nil)
        return;
    if (context.count <= 0)
    {
        [context addObject:[NSValue valueWithCGPoint:ptTo]];
        return;
    }
    
    CGPoint ptFrom = [context.lastObject CGPointValue];

    UIGraphicsBeginImageContext(self.maskImage.size);
    [self.maskImage drawInRect:CGRectMake(0, 0, self.maskImage.size.width, self.maskImage.size.height)];
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
    
    UIColor *alphaColor = [[UIColor blueColor] colorWithAlphaComponent:1.0f];
    CGContextSetStrokeColorWithColor(graphicsContext, alphaColor.CGColor);
    CGContextSetLineWidth(graphicsContext, maskWidth);
    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
    CGContextMoveToPoint(graphicsContext, ptFrom.x, ptFrom.y);
    CGContextAddLineToPoint(graphicsContext, ptTo.x, ptTo.y);
    CGContextStrokePath(graphicsContext);
    self.maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
//    NSLog(@"self.displayableMaskImage.size => width = %f, height = %f", self.displayableMaskImage.size.width, self.displayableMaskImage.size.height);
    
    
    NSMutableArray * arrayPixel = [self analyseBrightness:self.maskImage posFrom:ptFrom posTo:ptTo band:maskWidth];
    
    
    UIGraphicsBeginImageContext(self.displayableMaskImage.size);
    [self.displayableMaskImage drawInRect:CGRectMake(0, 0, self.displayableMaskImage.size.width, self.displayableMaskImage.size.height)];
    graphicsContext = UIGraphicsGetCurrentContext();
//    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
    
    
    for (NSDictionary * pos in arrayPixel) {
        int x = [pos[@"x"] intValue];
        int y = [pos[@"y"] intValue];
        
        UIColor *alphaColor = [self.displayableMaskColor colorWithAlphaComponent:[self getBrightness:x y:y]];
        
        CGContextSetFillColorWithColor(graphicsContext, alphaColor.CGColor);
        CGContextFillEllipseInRect(graphicsContext, CGRectMake(x, y, 1, 1));
        CGContextFillPath(graphicsContext);
        
    }
    
//    CGContextSetStrokeColorWithColor(graphicsContext, [UIColor yellowColor].CGColor);
//    CGContextSetLineWidth(graphicsContext, maskWidth);
//    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
//    CGContextMoveToPoint(graphicsContext, ptFrom.x, ptFrom.y);
//    CGContextAddLineToPoint(graphicsContext, ptTo.x, ptTo.y);
//    CGContextStrokePath(graphicsContext);
    
    
    
/*
    int x1 = ptFrom.x;
    int x2 = ptTo.x;
    int y1 = ptFrom.y;
    int y2 = ptTo.y;
    
    for (int delta = - maskWidth / 2 ; delta < maskWidth ; delta ++) {
//        if (x1 == x2) {
//            for (int y = y1 ; y1 < y2 ? y < y2 : y > y2 ; y1 < y2 ? y++ : y --) {
//                int x = x1 + delta;
//            
                UIColor *alphaColor = [self.displayableMaskColor colorWithAlphaComponent:[self getBrightness:x y:y]];
                
                CGContextSetFillColorWithColor(graphicsContext, alphaColor.CGColor);
                CGContextFillEllipseInRect(graphicsContext, CGRectMake(x, y, 1, 1));
                CGContextFillPath(graphicsContext);
//            }
//        }
//        else
        {
            for (int x = x1 ; x1 < x2 ? x < x2 : x > x2 ; x1 < x2 ? x++ : x --) {
                int y = (y2 - y1) * (x - x1)/(x2- x1) + y1 + delta;
                
                UIColor *alphaColor = [self.displayableMaskColor colorWithAlphaComponent:[self getBrightness:x y:y]];
                
                CGContextSetFillColorWithColor(graphicsContext, alphaColor.CGColor);
                CGContextFillEllipseInRect(graphicsContext, CGRectMake(x, y, 1, 1));
                CGContextFillPath(graphicsContext);
                
            }
        }
        
    }
*/
    self.displayableMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [context addObject:[NSValue valueWithCGPoint:ptTo]];
}

- (void)eraseMaskLineSegmentFrom:(CGPoint)pt1 to:(CGPoint)pt2 withMaskWidth:(CGFloat)maskWidth
{
    UIGraphicsBeginImageContext(self.maskImage.size);
    [self.maskImage drawInRect:CGRectMake(0, 0, self.maskImage.size.width, self.maskImage.size.height)];
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
    CGContextSetRGBStrokeColor(graphicsContext, 0, 0, 0, 1);
    CGContextSetLineWidth(graphicsContext, maskWidth);
    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
    CGContextMoveToPoint(graphicsContext, pt1.x, pt1.y);
    CGContextAddLineToPoint(graphicsContext, pt2.x, pt2.y);
    CGContextStrokePath(graphicsContext);
    self.maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.displayableMaskImage.size);
    [self.displayableMaskImage drawInRect:CGRectMake(0, 0, self.displayableMaskImage.size.width, self.displayableMaskImage.size.height)];
    graphicsContext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
    CGContextSetRGBStrokeColor(graphicsContext, 0, 0, 0, 0);
    CGContextSetLineWidth(graphicsContext, maskWidth);
    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
    CGContextMoveToPoint(graphicsContext, pt1.x, pt1.y);
    CGContextAddLineToPoint(graphicsContext, pt2.x, pt2.y);
    CGContextStrokePath(graphicsContext);
    self.displayableMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (NSMutableArray*) analyseBrightness:(UIImage*) img posFrom:(CGPoint) posFrom posTo:(CGPoint) posTo band:(int)band
{
    NSMutableArray * arrayPixelDrawing = [[NSMutableArray alloc] init];
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int width = img.size.width;
    int height = img.size.height;
    
    int leftLimit, rightLimit, topLimit, bottomLimit;
    if (posFrom.x < posTo.x) {
        leftLimit = posFrom.x-band < 0 ? 0 : posFrom.x-band;
        rightLimit = posTo.x+band > width ? width : posTo.x+band;
        if (posFrom.y < posTo.y) {
            topLimit = posFrom.y-band < 0 ? 0 : posFrom.y-band;
            bottomLimit = posTo.y+band > height ? height : posTo.y+band;
        }
        else {
            topLimit = posTo.y-band < 0 ? 0 : posTo.y-band;
            bottomLimit = posFrom.y+band > height ? height : posFrom.y+band;
        }
    }
    else {
        leftLimit = posTo.x-band < 0 ? 0 : posTo.x-band;
        rightLimit = posFrom.x+band > width ? width : posFrom.x+band;
        if (posFrom.y < posTo.y) {
            topLimit = posFrom.y-band < 0 ? 0 : posFrom.y-band;
            bottomLimit = posTo.y+band > height ? height : posTo.y+band;
        }
        else {
            topLimit = posTo.y-band < 0 ? 0 : posTo.y-band;
            bottomLimit = posFrom.y+band > height ? height : posFrom.y+band;
        }
    }
    
    for (int x = leftLimit ; x < rightLimit; x ++) {
        
        for (int y = topLimit; y < bottomLimit; y ++) {

            int pixelInfo = ((width  * y) + x ) * 4;
            
            UInt8 red = data[pixelInfo];
            UInt8 green = data[(pixelInfo + 1)];
            UInt8 blue = data[pixelInfo + 2];

//            NSLog(@"r = %d, g = %d, b = %d", red, green, blue);
            
            if (red == 255 && green == 0 && blue == 0) {
                NSDictionary *value = @{@"x":[NSNumber numberWithInt:x],
                                        @"y":[NSNumber numberWithInt:y]};
                [arrayPixelDrawing addObject:value];
            }
            
        }
    }
    
    CFRelease(pixelData);
    
    return arrayPixelDrawing;
}

- (float) getBrightness:(int) x y : (int) y
{
    if (_arrayBrightness != nil) {
        
        if (_arrayBrightness.count <= x) {
            return 0;
        }
        if (((NSArray*)_arrayBrightness[x]).count <= y) {
            return 0;
        }
        
        int brightness = [_arrayBrightness[x][y] intValue];
        
        float opacity = 1.0f;
        
        switch (brightness) {
            case 0:
            case 1:
                opacity = 0.1;
                break;
            case 2:
                opacity = 0.17;
                break;
            case 3:
                opacity = 0.24;
                break;
            case 4:
                opacity = 0.31;
                break;
            case 5:
                opacity = 0.38;
                break;
            case 6:
                opacity = 0.45;
                break;
            case 7:
                opacity = 0.52;
                break;
            case 8:
                opacity = 0.58;
                break;
            case 9:
                opacity = 0.64;
                break;
            case 10:
                opacity = 0.7;
                break;
        }
        
//        NSLog(@"opacity = %f", opacity);
        
        return opacity;
    }
    
    return 1;
}


- (void)drawInitMask:(CGFloat)maskWidth inContext:(NXMaskDrawContext)context
{
    if (context == nil)
        return;
    
    UIGraphicsBeginImageContext(self.maskImage.size);
    [self.maskImage drawInRect:CGRectMake(0, 0, self.maskImage.size.width, self.maskImage.size.height)];
//    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
//    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
//    CGContextSetRGBFillColor(graphicsContext, 1, 1, 1, 1);
//    //    CGContextSetRGBStrokeColor(graphicsContext, 1, 1, 1, 1);
//    //    CGContextSetLineWidth(graphicsContext, maskWidth);
//    //    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
//    //    CGContextMoveToPoint(graphicsContext, ptFrom.x, ptFrom.y);
//    //    CGContextAddLineToPoint(graphicsContext, ptTo.x, ptTo.y);
//    CGContextAddEllipseInRect(graphicsContext, rect);
//    //    CGContextStrokePath(graphicsContext);
//    CGContextFillPath(graphicsContext);
    self.maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.displayableMaskImage.size);
    [self.displayableMaskImage drawInRect:CGRectMake(0, 0, self.displayableMaskImage.size.width, self.displayableMaskImage.size.height)];
//    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
//    CGContextSetBlendMode(graphicsContext, kCGBlendModeCopy);
//    //    CGContextSetStrokeColorWithColor(graphicsContext, self.displayableMaskColor.CGColor);
//    //    CGContextSetLineWidth(graphicsContext, maskWidth);
//    //    CGContextSetLineCap(graphicsContext, kCGLineCapRound);
//    //    CGContextMoveToPoint(graphicsContext, ptFrom.x, ptFrom.y);
//    //    CGContextAddLineToPoint(graphicsContext, ptTo.x, ptTo.y);
//    //    CGContextStrokePath(graphicsContext);
//    CGContextSetFillColorWithColor(graphicsContext, [UIColor yellowColor].CGColor);
//    CGContextFillRect(graphicsContext, CGRectMake(0, 0, self.displayableMaskImage.size.width, self.displayableMaskImage.size.height));
//    CGContextFillPath(graphicsContext);
    self.displayableMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    [context addObject:[NSValue valueWithCGPoint:ptTo]];
}



- (void)setDisplayableMaskColor:(UIColor *)displayableMaskColor
{
    if (displayableMaskColor == nil)
        _displayableMaskColor = [UIColor greenColor];
    else
        _displayableMaskColor = displayableMaskColor;
}

- (void)setMyOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    
    if (_originalImage == nil)
    {
        self.maskImage = nil;
        self.displayableMaskImage = nil;
        return;
    }
    
    UIGraphicsBeginImageContext(_originalImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0);
    CGContextFillRect(ctx, CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height));
    self.maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(_originalImage.size);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0);
    CGContextFillRect(ctx, CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height));
    self.displayableMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(_originalImage.size);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0);
    CGContextFillRect(ctx, CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height));
    self.drawingmage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

/*
- (UIImage *)maskAppliedImage
{
    GPUImagePicture *maskPicture = [[GPUImagePicture alloc] initWithCGImage:self.originalImage.CGImage];
    GPUImageMaskFilter *maskFilter = [[GPUImageMaskFilter alloc] init];
    [maskPicture addTarget:maskFilter];
    [maskPicture processImage];
    UIImage *returnImage = [maskFilter imageByFilteringImage:self.maskImage];
    [maskPicture removeAllTargets];
    maskPicture = nil;
    maskFilter = nil;
    
    return returnImage;
}

- (CGRect)maskExtentRect
{
    int width = self.maskImage.size.width;
    int height = self.maskImage.size.height;
    int lineBytes = (width + 3) & (~3);
    
    unsigned char *data = (unsigned char *)malloc(lineBytes*height);
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef contextRef = CGBitmapContextCreate(data, width, height, 8, lineBytes, grayColorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), self.maskImage.CGImage);
    CGContextRelease(contextRef);
    
    int minX = width-1, maxX = 0, minY = height-1, maxY = 0;
    for (int i = 0; i < width; i ++)
    {
        for (int j = 0; j < height; j ++)
        {
            unsigned char pt_val = data[j*lineBytes+i];
            if (i == 0)
            {
                if (pt_val > 127)
                    minX = 0;
            }
            else if (i == width-1)
            {
                if (pt_val > 127)
                    maxX = width-1;
            }
            else
            {
                unsigned char before_val = data[j*lineBytes+i-1];
                unsigned char after_val = data[j*lineBytes+i+1];
                if (before_val <= 127 && pt_val > 127)
                    minX = minX < i ? minX : i;
                if (pt_val > 127 && after_val <= 127)
                    maxX = maxX > i ? maxX : i;
            }
            if (j == 0)
            {
                if (pt_val > 127)
                    minY = 0;
            }
            else if (j == height-1)
            {
                if (pt_val > 127)
                    maxY = height-1;
            }
            else
            {
                unsigned char before_val = data[(j-1)*lineBytes+i];
                unsigned char after_val = data[(j+1)*lineBytes+i];
                if (before_val <= 127 && pt_val > 127)
                    minY = minY < j ? minY : j;
                if (pt_val > 127 && after_val <= 127)
                    maxY = maxY > j ? maxY : j;
            }
        }
    }
    
    free(data);
    
    if (minX >= maxX || minY >= maxY)
        return CGRectZero;
    else
        return CGRectMake(minX, minY, maxX-minX, maxY-minY);
}

- (UIImage *)maskClipedImage
{
    CGRect rcExtent = [self maskExtentRect];
    if (rcExtent.size.width == 0.f || rcExtent.size.height == 0.f)
        return nil;
    
    GPUImagePicture *maskPicture = [[GPUImagePicture alloc] initWithCGImage:self.originalImage.CGImage];
    GPUImageMaskFilter *maskFilter = [[GPUImageMaskFilter alloc] init];
    [maskPicture addTarget:maskFilter];
    [maskPicture processImage];
    UIImage *resultImage = [maskFilter imageByFilteringImage:self.maskImage];
    [maskPicture removeAllTargets];
    maskPicture = nil;
    maskFilter = nil;
    UIImage *returnImage = [NXImageUtils imageByCrop:resultImage byRect:rcExtent];
    
    return returnImage;
}

- (void)updateDisplayableMaskImage
{
    UIGraphicsBeginImageContext(self.originalImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.displayableMaskColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.originalImage.size.width, self.originalImage.size.height));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    GPUImagePicture *maskPicture = [[GPUImagePicture alloc] initWithCGImage:colorImage.CGImage];
    GPUImageMaskFilter *maskFilter = [[GPUImageMaskFilter alloc] init];
    [maskPicture addTarget:maskFilter];
    [maskPicture processImage];
    self.displayableMaskImage = [maskFilter imageByFilteringImage:self.maskImage];
    [maskPicture removeAllTargets];
    maskPicture = nil;
    maskFilter = nil;
}
*/
@end
