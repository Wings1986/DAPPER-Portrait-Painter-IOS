#import "GPUImageFilter.h"

@interface GPUImageSampleFilter : GPUImageFilter
{
    GLint brightnessUniform;
    GLint contrastUniform;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat brightness;

/** Contrast ranges from 0.0 to 4.0 (max contrast), with 1.0 as the normal level
 */
@property(readwrite, nonatomic) CGFloat contrast;

@end
