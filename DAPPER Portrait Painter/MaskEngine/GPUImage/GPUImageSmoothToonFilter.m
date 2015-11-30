#import "GPUImageSmoothToonFilter.h"
#import "GPUImageBoxBlurFilter.h"
#import "GPUImageMinFilter.h"
#import "GPUImageToonFilter.h"

@implementation GPUImageSmoothToonFilter

@synthesize threshold;
@synthesize gamma;
@synthesize blurSize;
@synthesize quantizationLevels;
@synthesize texelWidth;
@synthesize texelHeight;

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    // First pass: apply a variable Gaussian blur
    boxBlurFilter = [[GPUImageBoxBlurFilter alloc] init];
    [self addFilter:boxBlurFilter];
    
    minFilter = [[GPUImageMinFilter alloc] init];
    [self addFilter:minFilter];
    
    // Second pass: run the Sobel edge detection on this blurred image, along with a posterization effect
    toonFilter = [[GPUImageToonFilter alloc] init];
    [self addFilter:toonFilter];
    
    // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
    [boxBlurFilter addTarget:minFilter];
    [minFilter addTarget:toonFilter];
    
    self.initialFilters = [NSArray arrayWithObject:boxBlurFilter];
    self.terminalFilter = toonFilter;
    
    self.blurSize = 0.5;
    self.gamma = 0.6;
    self.threshold = 0.2;
    self.quantizationLevels = 10.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurSize:(CGFloat)newValue;
{
    boxBlurFilter.blurSize = newValue;
}

- (CGFloat)blurSize;
{
    return boxBlurFilter.blurSize;
}

- (void)setTexelWidth:(CGFloat)newValue;
{
    toonFilter.texelWidth = newValue;
}

- (CGFloat)texelWidth;
{
    return toonFilter.texelWidth;
}

- (void)setTexelHeight:(CGFloat)newValue;
{
    toonFilter.texelHeight = newValue;
}

- (CGFloat)texelHeight;
{
    return toonFilter.texelHeight;
}

- (void)setThreshold:(CGFloat)newValue;
{
    toonFilter.threshold = newValue;
}

- (CGFloat)threshold;
{
    return toonFilter.threshold;
}

- (void)setQuantizationLevels:(CGFloat)newValue;
{
    toonFilter.quantizationLevels = newValue;
}

- (CGFloat)quantizationLevels;
{
    return toonFilter.quantizationLevels;
}

- (void)setGamma:(CGFloat)newValue
{
//    toonFilter.gamma = newValue;
}

- (CGFloat)gamma
{
//    return toonFilter.gamma;
    return 0.6f;
}

@end