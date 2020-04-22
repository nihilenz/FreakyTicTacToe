//
//  GameView.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 18/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "GameView.h"

@implementation GameView

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self)
    {
        // Just to simulate class properties of original app
        UIWindow *window;
        if (@available(iOS 11.0, *))
        {
            if (@available(iOS 13.0, *))
            {
                window = [UIApplication.sharedApplication.windows firstObject];
            }
            else
            {
                window = UIApplication.sharedApplication.keyWindow;
            }
            _topOffset = (window != nil ? window.safeAreaInsets.top : 0.0);
            _bottomOffset = (window != nil ? window.safeAreaInsets.bottom : 0.0);
        }
        else
        {
            _topOffset = 0.0;
            _bottomOffset = 0.0;
        }
        _width = [[UIScreen mainScreen] bounds].size.width;
        _height = [[UIScreen mainScreen] bounds].size.height;
    }
    return self;
}



#pragma mark -
#pragma mark Game life-cicly

- (void)gameDidAppear {}

- (void)setGame {}

- (void)resetGame {}

- (void)unloadGame {}



#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    _delegate = nil;
}

@end
