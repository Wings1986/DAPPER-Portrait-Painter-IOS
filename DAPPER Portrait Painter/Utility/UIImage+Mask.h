//
//  UIImage+Mask.h
//

#import <UIKit/UIKit.h>

@interface UIImage(Mask)

- (UIImage *)maskImageNamed:(UIColor *)color;

+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
    
@end

