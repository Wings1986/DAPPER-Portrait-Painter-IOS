//
//  GPUImageNeonFilter.m
//  Instamotion
//
//  Created by osone on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPUImageNeonFilter.h"

NSString *const kGPUImageNeonFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 const highp vec3 W = vec3(0.299, 0.580, 0.110);
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     float bottomLeftIntensity = dot(texture2D(inputImageTexture, bottomLeftTextureCoordinate).rgb, W);
     float topRightIntensity = dot(texture2D(inputImageTexture, topRightTextureCoordinate).rgb, W);
     float topLeftIntensity = dot(texture2D(inputImageTexture, topLeftTextureCoordinate).rgb, W);
     float bottomRightIntensity = dot(texture2D(inputImageTexture, bottomRightTextureCoordinate).rgb, W);
     float leftIntensity = dot(texture2D(inputImageTexture, leftTextureCoordinate).rgb, W);
     float rightIntensity = dot(texture2D(inputImageTexture, rightTextureCoordinate).rgb, W);
     float bottomIntensity = dot(texture2D(inputImageTexture, bottomTextureCoordinate).rgb, W);
     float topIntensity = dot(texture2D(inputImageTexture, topTextureCoordinate).rgb, W);
     float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
     float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
     
     float magnitude = (abs(h) + abs(v));
     if (magnitude < 0.0)
         magnitude = 0.0;
     else if (magnitude > 1.0)
         magnitude = 1.0;
     
     if (magnitude > 0.98)
         gl_FragColor = vec4(1.0);
     else if (magnitude < 0.2)
         gl_FragColor = vec4(vec3(0.0), 1.0);
     else
         gl_FragColor = vec4(0, magnitude, 0, 1.0);
 }
);

@implementation GPUImageNeonFilter

- (id)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageNeonFragmentShaderString];
    return self;
}

@end
