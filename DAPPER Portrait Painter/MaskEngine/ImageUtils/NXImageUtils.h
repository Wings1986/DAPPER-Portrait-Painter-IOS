//
//  NXImageUtils.h
//  LeafMask
//
//  Created by osone on 3/25/13.
//  Copyright (c) 2013 TEX Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 


@interface NXImageUtils : NSObject

+ (UIImage *)adjustImageOrientation:(UIImage *)image;
+ (UIImage *)squareImageByExpand:(UIImage *)image;
+ (UIImage *)rotateImage:(UIImage *)image withRotation:(CGFloat)radian;
+ (UIImage *)imageByScale:(UIImage *)image withScale:(CGFloat)scale;
+ (UIImage *)imageByResize:(UIImage *)image withSize:(CGSize)size;
+ (UIImage *)imageByScaleAndRotate:(UIImage *)image withScale:(CGFloat)scale;
+ (UIImage *)imageByCrop:(UIImage *)image byRect:(CGRect)rect;

@end
