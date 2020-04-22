//
//  FTTTMove.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "FTTTMove.h"

@implementation FTTTMove

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.value = 0;
        self.index = index;
    }
    return self;
}

@end
