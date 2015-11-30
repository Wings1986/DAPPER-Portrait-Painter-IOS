//
//  Global.h
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/26/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#ifndef DAPPER_Portrait_Painter_Global_h
#define DAPPER_Portrait_Painter_Global_h

#define UIColorFromRGB(rgbValue) \
            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 \
                            alpha:1.0]

#define UIColorFromRGBWithAlpha(rgbValue, alphaValue) \
            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 \
                            alpha:alphaValue]

#endif
