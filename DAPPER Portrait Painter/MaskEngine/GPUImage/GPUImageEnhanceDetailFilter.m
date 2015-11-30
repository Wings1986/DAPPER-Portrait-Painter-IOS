#import "GPUImageEnhanceDetailFilter.h"

@implementation GPUImageEnhanceDetailFilter

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    invertFilter = [[GPUImageColorInvertFilter alloc] init];
    [self addFilter:invertFilter];
    
    emptyFilter = [[GPUImageEmptyFilter alloc] init];
    [self addFilter:emptyFilter];
    
    overlayFilter = [[GPUImageOverlayBlendFilter alloc] init];
    [self addFilter:overlayFilter];
    
    [emptyFilter addTarget:overlayFilter];
    [invertFilter addTarget:overlayFilter];
    
    self.initialFilters = [NSArray arrayWithObjects:invertFilter, emptyFilter, nil];
    self.terminalFilter = overlayFilter;
    
    return self;
}

@end

