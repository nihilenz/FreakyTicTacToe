//
//  FTTTPlayer.h
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

typedef enum {
    FTTTMarkNone    = 0, // Empty
    FTTTMarkX       = 1, // User
    FTTTMarkO       = 2  // Bot
} FTTTMark;

@interface FTTTPlayer : NSObject <GKGameModelPlayer>

@property (nonatomic, readonly) NSInteger playerId;
@property (nonatomic, assign) FTTTMark mark;

+ (FTTTPlayer *)xPlayer;
+ (FTTTPlayer *)oPlayer;
+ (NSArray<FTTTPlayer *> *)all;
- (FTTTPlayer *)opponent;
+ (NSString *)stringForMark:(FTTTMark)mark;

@end
