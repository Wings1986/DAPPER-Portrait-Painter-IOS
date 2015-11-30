#import "GPUImageColorMatrixFilter.h"

NSString *const kGPUImageColorMatrixFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform lowp mat4 colorMatrix;
 uniform lowp float intensity;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 outputColor = textureColor * colorMatrix;
     
     gl_FragColor = (intensity * outputColor) + ((1.0 - intensity) * textureColor);
 }
);                                                                         

@implementation GPUImageColorMatrixFilter

@synthesize intensity = _intensity;
@synthesize colorMatrix = _colorMatrix;
@synthesize colorMatrixType = _colorMatrixType;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageColorMatrixFragmentShaderString]))
    {
        return nil;
    }
    
    colorMatrixUniform = [filterProgram uniformIndex:@"colorMatrix"];
    intensityUniform = [filterProgram uniformIndex:@"intensity"];
    
    self.intensity = 1.f;
    self.colorMatrix = (GPUMatrix4x4){
        {1.f, 0.f, 0.f, 0.f},
        {0.f, 1.f, 0.f, 0.f},
        {0.f, 0.f, 1.f, 0.f},
        {0.f, 0.f, 0.f, 1.f}
    };
    _colorMatrixType = 0.f;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setIntensity:(CGFloat)newIntensity;
{
    _intensity = newIntensity;
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(intensityUniform, _intensity);
}

- (void)setColorMatrix:(GPUMatrix4x4)newColorMatrix;
{
    _colorMatrix = newColorMatrix;
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    
    glUniformMatrix4fv(colorMatrixUniform, 1, GL_FALSE, (GLfloat *)&_colorMatrix);
}

- (void)setColorMatrixType:(CGFloat)newType;
{
    _colorMatrixType = newType;
    int nType = (int)floor(_colorMatrixType);
    switch (nType)
    {
    case 1:
        _colorMatrix = (GPUMatrix4x4){
            {0.f, 0.f, 0.f, 1.f},
            {0.f, 0.f, 1.f, 0.f},
            {0.f, 1.f, 0.f, 0.f},
            {1.f, 0.f, 0.f, 0.f}
        };
        break;
    case 2:
        _colorMatrix = (GPUMatrix4x4){
            {1.f, 0.f, 0.f, 0.f},
            {1.f, 1.f, 0.f, 0.f},
            {1.f, 1.f, 1.f, 0.f},
            {1.f, 1.f, 1.f, 1.f}
        };
        break;
    case 3:
        _colorMatrix = (GPUMatrix4x4){
            {1.f, 1.f, 1.f, 1.f},
            {0.f, 1.f, 1.f, 1.f},
            {0.f, 0.f, 1.f, 1.f},
            {0.f, 0.f, 0.f, 1.f}
        };
        break;
    case 4:
        _colorMatrix = (GPUMatrix4x4){
            {1.f, 1.f, 1.f, 1.f},
            {1.f, 1.f, 1.f, 0.f},
            {1.f, 1.f, 0.f, 0.f},
            {1.f, 0.f, 0.f, 0.f}
        };
        break;
    case 5:
        _colorMatrix = (GPUMatrix4x4){
            {0.f, 0.f, 0.f, 1.f},
            {0.f, 0.f, 1.f, 1.f},
            {0.f, 1.f, 1.f, 1.f},
            {1.f, 1.f, 1.f, 1.f}
        };
        break;
    default:
        _colorMatrix = (GPUMatrix4x4){
            {1.f, 0.f, 0.f, 0.f},
            {0.f, 1.f, 0.f, 0.f},
            {0.f, 0.f, 1.f, 0.f},
            {0.f, 0.f, 0.f, 1.f}
        };
        break;
    }
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    
    glUniformMatrix4fv(colorMatrixUniform, 1, GL_FALSE, (GLfloat *)&_colorMatrix);
}

@end
