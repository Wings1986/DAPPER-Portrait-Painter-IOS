#import "GPUImageFilterGroup.h"
#import "GPUImageColorInvertFilter.h"
#import "GPUImageOverlayBlendFilter.h"
#import "GPUImageEmptyFilter.h"

@interface GPUImageEnhanceDetailFilter : GPUImageFilterGroup
{
    GPUImageColorInvertFilter *invertFilter;
    GPUImageOverlayBlendFilter *overlayFilter;
    GPUImageEmptyFilter *emptyFilter;
}

@end
