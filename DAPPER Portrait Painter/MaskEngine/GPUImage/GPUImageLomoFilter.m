//
//  GPUImageLomoFilter.m
//  Instamotion
//
//  Created by osone on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPUImageLomoFilter.h"

@implementation GPUImageLomoFilter

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.vignetteStart = 0.2f;
        self.vignetteEnd = 0.9f;
    }
    return self;
}

@end
