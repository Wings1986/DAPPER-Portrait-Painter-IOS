//
//  GPUImageEmptyFilter.m
//  Instamotion
//
//  Created by osone on 8/2/12.
//  Copyright (c) 2012 ChengTong IT. Inc. All rights reserved.
//

#import "GPUImageEmptyFilter.h"

NSString *const kGPUImageEmptyFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = textureColor;
 }
 );

@implementation GPUImageEmptyFilter

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageEmptyFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
