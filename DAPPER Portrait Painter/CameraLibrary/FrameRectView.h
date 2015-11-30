#import <UIKit/UIKit.h>

@interface FrameRectView : UIView {
@private
    CGFloat centerY;
    CGRect targetFrameRect;
    
    UIColor *strokeColor;
    UIColor *fillColor;
    
    // for dragging
    CGPoint dragStartPoint;
    NSInteger direcX;
    NSInteger direcY;
}

// Initializer
- (id)initWithFrame:(CGRect)frame withCenterY:(CGFloat)y;

// Get target frame rect
@property (readonly) CGRect targetFrameRect;

@end