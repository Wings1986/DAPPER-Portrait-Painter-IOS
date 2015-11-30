#import "FrameRectView.h"

static const CGFloat kDefaultRectMinWidth = 50.0f;
static const CGFloat kDefaultRectMinHeight = 30.0f;

static const CGFloat kDefaultRectWidth = 220.0f;
static const CGFloat kDefaultRectHeight = 50.0f;
static const CGFloat kDefaultStrokeSize = 5.0f;


@interface FrameRectView ()

- (void)updateRectImage;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;

@end


@implementation FrameRectView

#pragma mark -

- (id)initWithFrame:(CGRect)frame withCenterY:(CGFloat)y {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // -- set position parameter
        {
            CGFloat startX = frame.size.width / 2 - kDefaultRectWidth / 2;
            
            if (y > 0) {
                centerY = y;
            } else {
                centerY = frame.size.height / 2;
            }
            
            targetFrameRect = CGRectMake(startX, centerY - kDefaultRectHeight / 2,
                                         kDefaultRectWidth, kDefaultRectHeight);
        }
        
        // -- set color parameter
        {
            [self setStrokeColor:[UIColor colorWithRed:1.0f
                                                 green:1.0f
                                                  blue:1.0f
                                                 alpha:1.0f]];
            [self setFillColor:[UIColor colorWithRed:1.0f
                                               green:1.0f
                                                blue:1.0f
                                               alpha:0.2f]];
        }
        
        // -- set gesturerecogonizer
        {
            UIGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(draggedView:)];
            [self addGestureRecognizer:dragGesture];
            [dragGesture release];
        }
    }
    return self;
}

#pragma mark -

- (void) drawRect : (CGRect)rect {
    // create bezierPath instance
    [self updateRectImage];
}


#pragma mark -
#pragma mark touch handling

- (void)draggedView:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint location = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        dragStartPoint = location;
        direcX = (self.frame.size.width / 2 < location.x) ? 1 : -1;
        direcY = (centerY < location.y) ? 1 : -1;
        return;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        dragStartPoint = CGPointZero;
        direcX = 0;
        direcY = 0;
        return;
    }
    
    CGFloat diffX = location.x - dragStartPoint.x;
    CGFloat diffY = location.y - dragStartPoint.y;
    
    CGRect newRect;
    newRect.size.width = targetFrameRect.size.width + direcX * diffX * 2;
    newRect.size.height = targetFrameRect.size.height + direcY * diffY * 2;
    
    if ( newRect.size.width > self.frame.size.width ) {
        newRect.size.width = self.frame.size.width;
    } else if (newRect.size.width < kDefaultRectMinWidth) {
        newRect.size.width = kDefaultRectMinWidth;
    }
    
    if ( newRect.size.height > centerY * 2 ) {
        newRect.size.height = centerY * 2;
    } else if ( newRect.size.height < kDefaultRectMinHeight ) {
        newRect.size.height = kDefaultRectMinHeight;
    }
    
    newRect.origin.x = self.frame.size.width / 2 - newRect.size.width / 2;
    newRect.origin.y = centerY - newRect.size.height / 2;
    
    targetFrameRect = newRect;
    [self setNeedsDisplay];
    
    dragStartPoint = location;
}


#pragma mark -
#pragma mark private methods

- (void)updateRectImage {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // set render color and style
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    aPath.lineWidth = 2;
    
    // set start point
    {
        CGFloat originX = targetFrameRect.origin.x;
        CGFloat originY = targetFrameRect.origin.y;
        CGFloat width = targetFrameRect.size.width;
        CGFloat height = targetFrameRect.size.height;
        
        [aPath moveToPoint:CGPointMake(originX, originY)];
        [aPath addLineToPoint:CGPointMake(originX+width, originY)];
        [aPath addLineToPoint:CGPointMake(originX+width, originY+height)];
        [aPath addLineToPoint:CGPointMake(originX, originY+height)];
        [aPath addLineToPoint:CGPointMake(originX, originY)];
    }
    
    // close path so that successed to create pentagon.
    [aPath closePath];
    
    //rendering
    [aPath stroke];
    [aPath fill];
}

#pragma mark -

- (void)dealloc {
    [strokeColor release];
    [fillColor release];
    [super dealloc];
}

@synthesize strokeColor;
@synthesize fillColor;

@synthesize targetFrameRect;

@end