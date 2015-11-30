//
//  OptionViewController.h
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/27/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingViewController.h"


@interface OptionViewController : UIViewController

@property (nonatomic, strong) DrawingViewController* drawingViewController;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) UIImage * captureImage;

@end
