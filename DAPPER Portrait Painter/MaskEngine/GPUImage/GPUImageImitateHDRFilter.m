//
//  GPUImageImitateHDRFilter.m
//  Instamotion
//
//  Created by osone on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPUImageImitateHDRFilter.h"

NSString *const kGPUImageImitateHDRFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 vec4 enhanceDetail2(vec4 texColor)
 {
     
 }
 
 void main()
 {
     
 }
);

@implementation GPUImageImitateHDRFilter

@end
