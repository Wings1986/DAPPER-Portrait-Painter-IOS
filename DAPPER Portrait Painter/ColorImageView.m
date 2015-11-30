//
//  ColorImageView.m
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import "ColorImageView.h"

@implementation ColorImageView

- (void) setMaskColor:(UIColor*) color
{
    self.mMaskColor = color;
    
    UIImage * maskImage = [self.image maskImageNamed:color];
    
    [self setImage:maskImage];
}

@end
