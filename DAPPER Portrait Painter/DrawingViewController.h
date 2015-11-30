//
//  DrawingViewController.h
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController

@property (nonatomic, strong) UIImage * originImg;
- (UIImage *) getCaptureImage:(NSString*) text;

@property (nonatomic, strong) NSDictionary * dicAssert;
- (void) setAssert:(NSDictionary*) assert title:(NSString*) name;
- (void) onNewPortrait;

@end
