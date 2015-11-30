//
//  NXMaskEngine.h
//  LeafMask
//
//  Created by osone on 3/21/13.
//  Copyright (c) 2013 TEX Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#define MAX_ZOOM_SCALE      300.f

typedef NSMutableArray* NXMaskDrawContext;

@interface NXMaskEngine : NSObject

@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIColor *displayableMaskColor;
@property (strong, nonatomic) UIImage *maskImage;
@property (strong, nonatomic) UIImage *displayableMaskImage;
@property (strong, nonatomic) UIImage *drawingmage;

@property (strong, nonatomic) NSMutableArray *arrayBrightness;


+ (NXMaskEngine *)sharedEngine;

- (NXMaskDrawContext)createDrawContext;
- (void)finalizeDrawContext:(NXMaskDrawContext)context withMaskWidth:(CGFloat)maskWidth;
- (void)saveMaskLineFirstPoint:(CGPoint)pt inContext:(NXMaskDrawContext)context;
- (void)drawMaskLineSegmentTo:(CGPoint)ptTo withMaskWidth:(CGFloat)maskWidth inContext:(NXMaskDrawContext)context;
- (void)eraseMaskLineSegmentFrom:(CGPoint)pt1 to:(CGPoint)pt2 withMaskWidth:(CGFloat)maskWidth;

- (void)drawInitMask:(CGFloat)maskWidth inContext:(NXMaskDrawContext)context;


//- (CGRect)maskExtentRect;
//- (UIImage *)maskAppliedImage;
//- (UIImage *)maskClipedImage;
//- (void)updateDisplayableMaskImage;

- (void)setMyOriginalImage:(UIImage *)originalImage;


@end
