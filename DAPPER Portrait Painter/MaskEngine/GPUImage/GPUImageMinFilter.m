//
//  GPUImageMinFilter.m
//  Instamotion
//
//  Created by osone on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPUImageMinFilter.h"

NSString *const kGPUImageMinFragmentShaderString = SHADER_STRING
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
 
 void main()
 {
     vec3 v[8];
     
     vec3 vc = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     v[0] = texture2D(inputImageTexture, topLeftTextureCoordinate).rgb;
     v[1] = texture2D(inputImageTexture, topTextureCoordinate).rgb;
     v[2] = texture2D(inputImageTexture, topRightTextureCoordinate).rgb;
     v[3] = texture2D(inputImageTexture, leftTextureCoordinate).rgb;
     v[4] = texture2D(inputImageTexture, rightTextureCoordinate).rgb;
     v[5] = texture2D(inputImageTexture, bottomLeftTextureCoordinate).rgb;
     v[6] = texture2D(inputImageTexture, bottomTextureCoordinate).rgb;     
     v[7] = texture2D(inputImageTexture, bottomRightTextureCoordinate).rgb;
     
     for (int i = 0; i < 8; i ++)
     {
         vc = min(vc, v[i]);
     }
     
     gl_FragColor = vec4(vc, 1.0);
 }
 );

@implementation GPUImageMinFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageMinFragmentShaderString]))
    {
		return nil;
    }
    
    hasOverriddenImageSizeFactor = NO;
    
    return self;
}

@end
