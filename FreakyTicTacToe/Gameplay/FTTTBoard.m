//
//  FTTTBoard.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "FTTTBoard.h"

@interface FTTTBoard ()
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger marks;
@property (nonatomic, assign) FTTTMark firstMark;
@property (nonatomic, assign) BOOL debug;
@end

@implementation FTTTBoard

- (instancetype)initWithSize:(NSInteger)size marks:(NSInteger)marks firstMark:(FTTTMark)firstMark
{
    self = [super init];
    if (self)
    {
        self.size = size;
        self.marks = marks;
        self.firstMark = firstMark;
        self.debug = NO;
        
        self.currentPlayer = (firstMark == FTTTMarkO ? [FTTTPlayer oPlayer] : [FTTTPlayer xPlayer]);
        
        NSInteger capacity = size * size;
        self.cells = [[NSMutableArray alloc] initWithCapacity:capacity];
        for (NSInteger i=0; i<capacity; i++)
        {
            [_cells addObject:@(FTTTMarkNone)];
        }
    }
    return self;
}

- (NSString *)cellsString
{
    NSString *log = @"";
    for (NSInteger i=0; i<[self.cells count]; i++)
    {
        FTTTMark mark = (FTTTMark)[[self.cells objectAtIndex:i] integerValue];
        log = [log stringByAppendingFormat:@"%d ", mark];
    }
    return log;
}

- (void)updateCell:(NSInteger)index
{
    FTTTMark mark = (FTTTMark)[[self.cells objectAtIndex:index] integerValue];
    if (mark == FTTTMarkNone)
    {
        [self.cells replaceObjectAtIndex:index withObject:@(self.currentPlayer.mark)];
        self.currentPlayer = [self.currentPlayer opponent];
    }
}

- (BOOL)isGameOver
{
    return ![self.cells containsObject:@(FTTTMarkNone)]
        || [self isWinForPlayer:self.currentPlayer]
        || [self isLossForPlayer:self.currentPlayer];
}


- (NSMutableArray *)lines
{
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i < self.size; i++)
    {
        for (NSInteger subJ=0; subJ < (self.size - self.marks + 1); subJ++)
        {
            NSMutableArray *line = [[NSMutableArray alloc] init];
            for (NSInteger j=subJ; j < (subJ + self.marks); j++)
            {
                [line addObject:@(j + self.size * i)];
            }
            [lines addObject:line];
        }
    }
    
    for (NSInteger subJ=0; subJ < (self.size - self.marks + 1); subJ++)
    {
        for (NSInteger i=0; i < self.size; i++)
        {
            NSMutableArray *line = [[NSMutableArray alloc] init];
            for (NSInteger j=subJ; j < (subJ + self.marks); j++)
            {
                [line addObject:@(i + self.size * j)];
            }
            [lines addObject:line];
        }
    }
    
    for (NSInteger subJ=0; subJ < (self.size - self.marks + 1); subJ++)
    {
        for (NSInteger i=0; i < (self.size - self.marks + 1); i++)
        {
            NSMutableArray *line = [[NSMutableArray alloc] init];
            for (NSInteger j=subJ; j < (subJ + self.marks); j++)
            {
                [line addObject:@(i + (self.size + 1) * j - subJ)];
            }
            [lines addObject:line];
        }
    }

    for (NSInteger subJ=0; subJ < (self.size - self.marks + 1); subJ++)
    {
        for (NSInteger i = (self.marks - 1); i < self.size; i++)
        {
            NSMutableArray *line = [[NSMutableArray alloc] init];
            for (NSInteger j=subJ; j < (subJ + self.marks); j++)
            {
                [line addObject:@(i + (self.size - 1) * j + subJ)];
            }
            [lines addObject:line];
        }
    }
    //NSLog(@"Lines: %@", lines);
    return lines;
}


- (NSInteger)checksForPlayer:(id<GKGameModelPlayer>)gameModelPlayer
{
    if (![gameModelPlayer isKindOfClass:[FTTTPlayer class]])
    {
        return 0;
    }
    FTTTPlayer *player = (FTTTPlayer *)gameModelPlayer;
    NSInteger count = 0;
    
    for (NSMutableArray *line in [self lines])
    {
        NSInteger opponentCount = 0;
        NSInteger noneCount = 0;
        for (NSNumber *cell in line)
        {
            FTTTMark mark = (FTTTMark)[[self.cells objectAtIndex:[cell integerValue]] integerValue];
            if (mark == [player mark])
            {
            }
            else if (mark == [[player opponent] mark])
            {
                opponentCount += 1;
            }
            else
            {
                noneCount += 1;
            }
        }
        if (noneCount == 1 && opponentCount == (self.marks - 1))
        {
            count += 1;
        }
    }
    return count;
}



#pragma mark - GKGameModel protocol

- (NSArray<id<GKGameModelPlayer>> *)players
{
    return [FTTTPlayer all];
}


- (id<GKGameModelPlayer>)activePlayer
{
    return self.currentPlayer;
}


- (NSArray<id<GKGameModelUpdate>> *)gameModelUpdatesForPlayer:(id<GKGameModelPlayer>)player
{
    NSMutableArray<FTTTMove *> *moves = [[NSMutableArray alloc] init];
    [self.cells enumerateObjectsUsingBlock:^(NSNumber *cell, NSUInteger index, BOOL *stop)
    {
        if ((FTTTMark)[cell integerValue] == FTTTMarkNone)
        {
            FTTTMove *move = [[FTTTMove alloc] initWithIndex:index];
            [moves addObject:move];
        }
    }];
    return moves;
}


- (void)applyGameModelUpdate:(id<GKGameModelUpdate>)gameModelUpdate
{
    if ([gameModelUpdate isKindOfClass:[FTTTMove class]])
    {
        FTTTMove *move = (FTTTMove *)gameModelUpdate;
        [self updateCell:[move index]];
    }
}


- (void)setGameModel:(id<GKGameModel>)gameModel
{
    if ([gameModel isKindOfClass:[FTTTBoard class]])
    {
        FTTTBoard *board = (FTTTBoard *)gameModel;
        self.cells = [NSMutableArray arrayWithArray:[board cells]];
        self.debug = [board debug];
        self.currentPlayer = [board currentPlayer];
    }
}


- (BOOL)isWinForPlayer:(id<GKGameModelPlayer>)gameModelPlayer
{
    if (![gameModelPlayer isKindOfClass:[FTTTPlayer class]])
    {
        return NO;
    }
    FTTTPlayer *player = (FTTTPlayer *)gameModelPlayer;
    for (NSMutableArray *line in [self lines])
    {
        NSInteger count = 0;
        for (NSNumber *cell in line)
        {
            FTTTMark mark = (FTTTMark)[[self.cells objectAtIndex:[cell integerValue]] integerValue];
            if (mark == [player mark])
            {
                count += 1;
            }
        }
        if (count == self.marks)
        {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isLossForPlayer:(id<GKGameModelPlayer>)gameModelPlayer
{
    if (![gameModelPlayer isKindOfClass:[FTTTPlayer class]])
    {
        return NO;
    }
    
    FTTTPlayer *player = (FTTTPlayer *)gameModelPlayer;
    return [self isWinForPlayer:[player opponent]];
}


- (NSInteger)scoreForPlayer:(id<GKGameModelPlayer>)player
{
    NSInteger score = (-1 * [self checksForPlayer:player]);
    
    if (self.debug)
    {
        NSString *log = @"\n";
        for (NSInteger i=0; i<self.size; i++)
        {
            for (NSInteger j=0; j<self.size; j++)
            {
                FTTTMark mark = (FTTTMark)[[self.cells objectAtIndex:(self.size - i - 1 + j * self.size)] integerValue];
                NSString *text = [FTTTPlayer stringForMark:mark];
                log = [log stringByAppendingString:(mark == FTTTMarkNone ? @"*" : text)];
            
            }
            log = [log stringByAppendingString:@"\n"];
        }
        log = [log stringByAppendingFormat:@"score: %ld\n", (long)score];
        NSLog(@"scoreForPlayer: %@", log);
    }
    
    return score;
}



#pragma mark - NSCopying protocol

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    FTTTBoard *board = [[FTTTBoard alloc] initWithSize:self.size marks:self.marks firstMark:self.firstMark];
    [board setGameModel:self];
    return board;
}

@end
