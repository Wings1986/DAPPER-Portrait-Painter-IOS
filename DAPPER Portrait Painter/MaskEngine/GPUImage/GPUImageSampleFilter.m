#import "GPUImageSampleFilter.h"

NSString *const kGPUImageSampleFilterFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float brightness;
 uniform lowp float contrast;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = (textureColor / contrast) - brightness;
 }
);

@implementation GPUImageSampleFilter

@synthesize brightness = _brightness;
@synthesize contrast = _contrast;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSampleFilterFragmentShaderString]))
    {
		return nil;
    }
    
    brightnessUniform = [filterProgram uniformIndex:@"brightness"];
    contrastUniform = [filterProgram uniformIndex:@"contrast"];
    self.brightness = 0.0;
    self.contrast = 1.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBrightness:(CGFloat)newValue;
{
    _brightness = newValue;
    
    [self setFloat:_brightness forUniform:brightnessUniform program:filterProgram];
}

- (void)setContrast:(CGFloat)newValue;
{
    _contrast = newValue;
    
    [self setFloat:_contrast forUniform:contrastUniform program:filterProgram];
}

@end
