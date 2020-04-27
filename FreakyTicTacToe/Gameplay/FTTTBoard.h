//
//  FTTTBoard.h
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "FTTTPlayer.h"
#import "FTTTMove.h"
#import "FTTTControl.h"

@interface FTTTBoard : NSObject <GKGameModel>

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cells;
@property (nonatomic, strong) FTTTPlayer *currentPlayer;
@property (nonatomic, strong) NSArray *winningLine;

- (instancetype)initWithSize:(NSInteger)size marks:(NSInteger)marks firstMark:(FTTTMark)firstMark;
- (void)updateCell:(NSInteger)index;
- (BOOL)isGameOver;

@end
