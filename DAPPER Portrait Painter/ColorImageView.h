//
//  ColorImageView.h
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+Mask.h"

@interface ColorImageView : UIImageView

@property (nonatomic, strong) UIColor * mMaskColor;

- (void) setMaskColor:(UIColor*) color;

@end
