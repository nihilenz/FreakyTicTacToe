//
//  FTTTPlayer.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "FTTTPlayer.h"

static NSMutableArray <FTTTPlayer *> *_players;

@implementation FTTTPlayer

- (instancetype)initWithMark:(FTTTMark)mark
{
    self = [super init];
    if (self)
    {
        self.mark = mark;
    }
    return self;
}


+ (NSMutableArray *)players
{
    if (_players == nil)
    {
        _players = [[NSMutableArray alloc] initWithObjects:
                    [[FTTTPlayer alloc] initWithMark:FTTTMarkX],
                    [[FTTTPlayer alloc] initWithMark:FTTTMarkO],
                    nil];
    }
    return _players;
}


+ (FTTTPlayer *)xPlayer
{
    return [[FTTTPlayer players] objectAtIndex:(FTTTMarkX - 1)];
}


+ (FTTTPlayer *)oPlayer
{
    return [[FTTTPlayer players] objectAtIndex:(FTTTMarkO - 1)];
}


+ (NSArray<FTTTPlayer *> *)all
{
    return [FTTTPlayer players];
}


- (FTTTPlayer *)opponent
{
    switch (self.mark)
    {
        case FTTTMarkX:
            return [FTTTPlayer oPlayer];
        case FTTTMarkO:
            return [FTTTPlayer xPlayer];
        default:
            return nil;
    }
}


- (NSInteger)playerId
{
    return self.mark;
}


+ (NSString *)stringForMark:(FTTTMark)mark
{
    switch (mark) {
        case FTTTMarkX:
            return @"x";
        case FTTTMarkO:
            return @"o";
        default:
            return @"";
    }
}

@end
