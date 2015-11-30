//
//  GPUImageThermalFilter.m
//  Instamotion
//
//  Created by osone on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPUImageHeatMapFilter.h"

NSString *const kGPUImageHeatMapFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
{
    vec3 tc = vec3(1.0, 0.0, 0.0);
    lowp vec3 pixcol = texture2D(inputImageTexture, textureCoordinate).rgb;
    vec3 colors[3];
    colors[0] = vec3(0.,0.,1.);
    colors[1] = vec3(1.,1.,0.);
    colors[2] = vec3(1.,0.,0.);
    float lum = dot(vec3(0.30, 0.59, 0.11), pixcol.rgb);
    int ix = (lum < 0.5)? 0:1;
    tc = mix(colors[ix],colors[ix+1],(lum-float(ix)*0.5)/0.5);
    
    gl_FragColor = vec4(tc, 1.0);
}
);

@implementation GPUImageHeatMapFilter

- (id)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageHeatMapFragmentShaderString];
    return self;
}

@end
