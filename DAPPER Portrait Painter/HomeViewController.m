//
//  HomeViewController.m
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import "HomeViewController.h"
#import "Global.h"
#import "ColorImageView.h"

#import "AppDelegate.h"
#import "URBAlertView.h"

@interface HomeViewController ()
{
    
    IBOutlet ColorImageView *mPaintColor1;
    IBOutlet ColorImageView *mPaintColor2;
    IBOutlet ColorImageView *mPaintColor3;
    IBOutlet ColorImageView *mPaintColor4;
    IBOutlet ColorImageView *mPaintColor5;
    IBOutlet ColorImageView *mPaintColor6;
    IBOutlet ColorImageView *mPaintColor7;
    IBOutlet ColorImageView *mPaintColor8;
    IBOutlet ColorImageView *mPaintColorSelect;
    
    __weak IBOutlet UIButton *btnNew;
    __weak IBOutlet UIButton *btnOpen;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ((AppDelegate*)[UIApplication sharedApplication].delegate).m_HomeViewController = self;
    
    [mPaintColor1 setMaskColor:UIColorFromRGB(0x304c39)];
    [mPaintColor2 setMaskColor:UIColorFromRGB(0x40275c)];
    [mPaintColor3 setMaskColor:UIColorFromRGB(0x004c95)];
    [mPaintColor4 setMaskColor:UIColorFromRGB(0x4c89b2)];
    [mPaintColor5 setMaskColor:UIColorFromRGB(0xffe5d9)];
    [mPaintColor6 setMaskColor:UIColorFromRGB(0xffc3a8)];
    [mPaintColor7 setMaskColor:UIColorFromRGB(0xb26f51)];
    [mPaintColor8 setMaskColor:UIColorFromRGB(0x7f736d)];
    [mPaintColorSelect setMaskColor:UIColorFromRGB(0xb26f51)];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        btnNew.enabled = NO;
        btnOpen.enabled = NO;

        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"NOTE"
                                                              message:@"This app is for iphone only"
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
        [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
            
            [alertView hideWithCompletionBlock:^{
                // stub
                if (buttonIndex == 0) { // YES
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        
                    });
                }
            }];
        }];
        [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
