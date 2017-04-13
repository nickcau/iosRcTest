//
//  RCMenu.m
//  RCMenu
//
//  Created by lamsion.chen on 4/9/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.


#import "RCMenu.h"
#import "RCColor.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const rcMenuCircelRadius = 135.0f;
static CGFloat const rcMenuDefaultEndRadius = 120.0f;
static CGFloat const rcMenuDefaultFarRadius = 140.0f;
static CGFloat const rcMenuDefaultStartPointX = 160.0;
static CGFloat const rcMenuDefaultStartPointY = 240.0;
static CGFloat const rcMenuDefaultTimeOffset = 0.01f;
static CGFloat const rcMenuDefaultRotateAngle = 0.0;
static CGFloat const rcMenuDefaultMenuWholeAngle = M_PI * 2;
static CGFloat const rcMenuDefaultExpandRotation = M_PI ;
static CGFloat const rcMenuDefaultCloseRotation = M_PI * 2;
static CGFloat const rcMenuDefaultAnimationDuration = 0.5f;
static CGFloat const rcMenuStartMenuDefaultAnimationDuration = 0.3f;
static BOOL const rcMenuStartMenuDefaultStartRotate = YES;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}

@interface RCMenu ()
- (void)_expand;
- (void)_close;
- (void)_setMenu;
- (CAAnimationGroup *)_blowupAnimationAtPoint:(RCMenuItem *)p;
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p;
@end

@implementation RCMenu {
    NSArray *_menusArray;
    NSUInteger _flag;
    NSTimer *_timer;
    RCMenuItem *_startButton;
    id<RCMenuDelegate> __weak _delegate;
    BOOL _isAnimating;
}


@synthesize radius, endRadius, farRadius, timeOffset, rotateAngle, menuWholeAngle, startPoint, expandRotation, closeRotation, animationDuration,selectedIndex,startRotate,overlayWindow;
@synthesize expanding = _expanding;
@synthesize delegate = _delegate;
@synthesize menusArray = _menusArray;

#pragma mark - Initialization & Cleaning up
- (id)initWithFrame:(CGRect)frame startItem:(RCMenuItem*)startItem optionMenus:(NSArray *)aMenusArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.endRadius = rcMenuDefaultEndRadius;
        self.farRadius = rcMenuDefaultFarRadius;
        self.timeOffset = rcMenuDefaultTimeOffset;
        self.rotateAngle = rcMenuDefaultRotateAngle;
        self.menuWholeAngle = rcMenuDefaultMenuWholeAngle;
        self.startPoint = CGPointMake(rcMenuDefaultStartPointX, rcMenuDefaultStartPointY);
        self.expandRotation = rcMenuDefaultExpandRotation;
        self.closeRotation = rcMenuDefaultCloseRotation;
        self.animationDuration = rcMenuDefaultAnimationDuration;
        self.startRotate = rcMenuStartMenuDefaultStartRotate;
        self.radius = rcMenuCircelRadius;
        
        self.menusArray = aMenusArray;
        
        // assign startItem to "Add" Button.
        _startButton = startItem;
        _startButton.delegate = self;
        _startButton.center = self.startPoint;
        
        self.overlayWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.overlayWindow setBackgroundColor:[RCColor RCBlue:1.0]];
//        [self addSubview:self.overlayWindow];
        [self.overlayWindow setHidden:YES];
        
        [self addSubview:_startButton];
        //        [_startButton addSubview:bgView];
    }
    return self;
}


#pragma mark - Getters & Setters

- (void)setStartPoint:(CGPoint)aPoint
{
    startPoint = aPoint;
    _startButton.center = aPoint;
}

- (void)setStartRotate:(BOOL)rotate
{
    startRotate =rotate ;
}

#pragma mark - images

- (void)setImage:(UIImage *)image {
    _startButton.image = image;
}

- (UIImage*)image {
    return _startButton.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    _startButton.highlightedImage = highlightedImage;
}

- (UIImage*)highlightedImage {
    return _startButton.highlightedImage;
}


- (void)setContentImage:(UIImage *)contentImage {
    _startButton.contentImageView.image = contentImage;
}

- (UIImage*)contentImage {
    return _startButton.contentImageView.image;
}

- (void)setHighlightedContentImage:(UIImage *)highlightedContentImage {
    _startButton.contentImageView.highlightedImage = highlightedContentImage;
}

- (UIImage*)highlightedContentImage {
    return _startButton.contentImageView.highlightedImage;
}



#pragma mark - UIView's methods
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //NSLog(@"point is:%f",point.y);
    // if the menu is animating, prevent touches
    if (_isAnimating)
    {
        return NO;
    }
    // if the menu state is expanding, everywhere can be touch
    // otherwise, only the add button are can be touch
    
    
    if (YES == _expanding)
    {
        return YES;
    }
    else
    {
        return CGRectContainsPoint(_startButton.frame, point);
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.expanding = !self.isExpanding;
    [_delegate startClose];
}

#pragma mark - AwesomeMenuItem delegates
- (void)RCMenuItemTouchesBegan:(RCMenuItem *)item
{
    [_delegate startClose];
    if (item == _startButton)
    {
        self.expanding = !self.isExpanding;
    }
}
- (void)AwesomeMenuItemTouchesEnd:(RCMenuItem *)item
{
    // exclude the "add" button
    if (item == _startButton)
    {
        return;
    }
    
    
    //    [self selectedFlag:item.tag];
    
    [self setSelectedIndex:item.tag];
    
    
    [self.overlayWindow setCenter:item.center];
    [self.overlayWindow.layer setCornerRadius:25];
    
    if ([_delegate respondsToSelector:@selector(rcMenu:didSelectIndex:)])
    {
        [_delegate rcMenu:self didSelectIndex:self.selectedIndex-1000];
    }
    
    
    // blowup the selected menu button
    
//    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item];
//    [item.layer addAnimation:blowup forKey:@"blowup"];
//    [self.overlayWindow.layer addAnimation:blowup forKey:@"blowup"];
    
    item.center = CGPointMake(-item.endPoint.x, -item.endPoint.y);
    
    // shrink other menu buttons
    for (int i = 0; i < [_menusArray count]; i ++)
    {
        RCMenuItem *otherItem = [_menusArray objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        otherItem.center =  CGPointMake(-otherItem.endPoint.x, -otherItem.endPoint.y);
        
    }
    _expanding = NO;
    
    //     rotate start button
    
    if (self.startRotate) {
        float angle = self.isExpanding ? -M_PI_4 : 0.0f;
        [UIView animateWithDuration:animationDuration animations:^{
            _startButton.transform = CGAffineTransformMakeRotation(angle);
        }];
    }
    
    
    
}

#pragma mark - Instant methods
- (void)setMenusArray:(NSArray *)aMenusArray
{
    if (aMenusArray == _menusArray)
    {
        return;
    }
    _menusArray = [aMenusArray copy];
    
    
    // clean subviews
    for (UIView *v in self.subviews)
    {
        if (v.tag >= 1000)
        {
            [v removeFromSuperview];
        }
    }
}



- (void)_setMenu {
    NSUInteger count = [_menusArray count];
    for (int i = 0; i < count; i ++)
    {
        RCMenuItem *item = [_menusArray objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = startPoint;
        
        // avoid overlap
        if (menuWholeAngle >= M_PI * 2) {
            menuWholeAngle = menuWholeAngle - menuWholeAngle / count;
        }
        
        CGPoint endPoint = CGPointMake(self.window.bounds.size.width/2 + sinf( - M_PI_4+(i*M_PI_4/1.5))*self.radius, self.window.bounds.size.height - cosf(- M_PI_4+(i*M_PI_4/1.5))*self.radius);
        item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle);
        
        item.center = CGPointMake(-item.endPoint.x, -item.endPoint.y);
        
        item.delegate = self;
        [self insertSubview:item belowSubview:_startButton];
    }
}


- (BOOL)isExpanding
{
    return _expanding;
}
- (void)setExpanding:(BOOL)expanding
{
    if (expanding) {
        [self _setMenu];
    }
    
    _expanding = expanding;
    
    // rotate add button
    if (self.startRotate) {
        float angle = self.isExpanding ? M_PI_4 : 0.0f;
        //        float scare = self.isExpanding ? 1.2f : 1.0f;
        [UIView animateWithDuration:rcMenuStartMenuDefaultAnimationDuration animations:^{
            _startButton.transform = CGAffineTransformMakeRotation(angle);
            //            _startButton.transform = CGAffineTransformMakeScale(scare, scare);
        }];
    }else{
        [UIView animateWithDuration:rcMenuStartMenuDefaultAnimationDuration animations:^{
            _startButton.transform = CGAffineTransformMakeScale(1.4, 1.4);
        }];
        [UIView animateWithDuration:rcMenuStartMenuDefaultAnimationDuration animations:^{
            _startButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    
    
    // expand or close animation
    if (!_timer)
    {
        _flag = self.isExpanding ? 0 : ([_menusArray count] - 1);
        SEL selector = self.isExpanding ? @selector(_expand) : @selector(_close);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        _timer = [NSTimer timerWithTimeInterval:timeOffset target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
    }
}
#pragma mark - Private methods
- (void)_expand
{
    
    if (_flag == [_menusArray count])
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSUInteger tag = 1000 + _flag;
    RCMenuItem *item = (RCMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = animationDuration;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    pathAnimation.delegate = self;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    CGPathAddArc(curvedPath, NULL, self.window.bounds.size.width/2, self.window.bounds.size.height, self.radius, -5.6*M_PI_4/1.5 , -5.5*M_PI_4/1.5 + (tag-999)*(M_PI_4/1.5), NO);
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:1.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects: pathAnimation, nil];
    //    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(_flag == [_menusArray count] - 1){
        [animationgroup setValue:@"firstAnimation" forKey:@"id"];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
    
    
}


////This draws a quadratic bezier curved line right across the screen
//- (void) drawACurvedLine {
//    //Create a bitmap graphics context, you will later get a UIImage from this
//    UIGraphicsBeginImageContext(CGSizeMake(320,460));
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    //Set variables in the context for drawing
//    CGContextSetLineWidth(ctx, 1.5);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//
//    //Set the start point of your drawing
////    CGContextMoveToPoint(ctx, 0, 200);
//    //The end point of the line is 310,450 .... i'm also setting a reference point of 10,450
//    //A quadratic bezier curve is drawn using these coordinates - experiment and see the results.
////    CGContextAddQuadCurveToPoint(ctx, 10, 50, 10, 50);
//    //Add another curve, the opposite of the above - finishing back where we started
////    CGContextAddQuadCurveToPoint(ctx, 310, 10, 10, 10);
//    CGContextAddArc(ctx, rcMenuCircelStartPointX, rcMenuCircelStartPointY, rcMenuCircelRadius, M_PI, -M_PI, YES);
//
//    //Draw the line
//    CGContextDrawPath(ctx, kCGPathStroke);
//
//    //Get a UIImage from the current bitmap context we created at the start and then end the image context
//    UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //With the image, we need a UIImageView
//    UIImageView *curveView = [[UIImageView alloc] initWithImage:curve];
//    //Set the frame of the view - which is used to position it when we add it to our current UIView
//    curveView.frame = CGRectMake(1, 1, 320, 460);
//    curveView.backgroundColor = [UIColor clearColor];
//    [self addSubview:curveView];
//}


- (void)_close
{
    if (_flag == -1)
    {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSUInteger tag = 1000 + _flag;
    RCMenuItem *item = (RCMenuItem *)[self viewWithTag:tag];
    
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = animationDuration;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    pathAnimation.delegate = self;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    CGPathAddArc(curvedPath, NULL, self.window.bounds.size.width/2, self.window.bounds.size.height, self.radius, -5.5*M_PI_4/1.5 + (tag-999)*(M_PI_4/1.5),-6*M_PI_4/1.5  , YES);
    
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:pathAnimation,  nil];
    //    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = animationDuration - 0.05;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationgroup.delegate = self;
    if(_flag == 0){
        [animationgroup setValue:@"lastAnimation" forKey:@"id"];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    
    item.center = CGPointMake(-item.endPoint.x, -item.endPoint.y);
    
    _flag --;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"id"] isEqual:@"clicked"]) {
        [self.overlayWindow setHidden:YES];
    }
    
    
    if([[anim valueForKey:@"id"] isEqual:@"lastAnimation"]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(rcMenuDidFinishAnimationClose:)]){
            [self.delegate rcMenuDidFinishAnimationClose:self];
            
        }
    }
    if([[anim valueForKey:@"id"] isEqual:@"firstAnimation"]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(rcMenuDidFinishAnimationOpen:)]){
            [self.delegate rcMenuDidFinishAnimationOpen:self];
        }
    }
}
- (CAAnimationGroup *)_blowupAnimationAtPoint:(RCMenuItem *)p
{
    [self.overlayWindow setHidden:NO];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p.center], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    //
    //    CGMutablePathRef path = CGPathCreateMutable();
    //    CGPathMoveToPoint(path, NULL, p.center.x, p.center.y);
    //    CGPathAddLineToPoint(path, NULL, self.window.bounds.size.width/2,self.window.bounds.size.height/2);
    //    positionAnimation.path = path;
    //    CGPathRelease(path);
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    //
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation,opacityAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeBoth;
    animationgroup.delegate = self;
    [animationgroup setValue:@"clicked" forKey:@"id"];
    
    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}





@end
