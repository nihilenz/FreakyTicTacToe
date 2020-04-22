//
//  FTTTControl.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 17/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "FTTTControl.h"

#define kLineWidth 4.0f

@implementation FTTTControl

- (void)setMark:(FTTTMark)mark
{
    BOOL different = (_mark != mark);
    
    // Setter
    _mark = mark;
    
    if (different)
    {
        [self drawMark];
    }
}


- (void)drawMark
{
    // Remove all sublayers
    for (CALayer *layer in [self.layer sublayers])
    {
        [layer removeFromSuperlayer];
    }
    
    // Sizes
    CGFloat padding = roundf(self.frame.size.width * 0.15);
    CGFloat size = self.frame.size.width - (padding * 2);
    
    // Bezier path
    UIBezierPath *path;
    if (self.mark == FTTTMarkO)
    {
        // Oval path
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(padding, padding, size, size)];
    }
    else if (self.mark == FTTTMarkX)
    {
        // Cross path
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(padding, padding)];
        [path addLineToPoint:CGPointMake(padding + size, padding + size)];
        [path moveToPoint:CGPointMake(padding + size, padding)];
        [path addLineToPoint:CGPointMake(padding, padding + size)];
    }
    
    // Shape layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = kLineWidth;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    
    // Add animation "Stroke End"
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.duration = 0.4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:@"FTTTControlAnimation"];
}

@end
