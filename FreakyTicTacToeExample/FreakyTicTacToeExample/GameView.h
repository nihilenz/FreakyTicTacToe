//
//  GameView.h
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 18/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FAPriorityLevelVeryHigh    = 0,
    FAPriorityLevelHigh        = 1,
    FAPriorityLevelMedium      = 2,
    FAPriorityLevelLow         = 3,
    FAPriorityLevelVeryLow     = 4
} FAPriorityLevel;



@protocol GameViewDelegate <NSObject>

@property (nonatomic) FAPriorityLevel priorityLevel;

- (void)manageGameResult:(BOOL)isCorrectResult;

@end



@interface GameView : UIView

@property (nonatomic, weak) id<GameViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat topOffset;
@property (nonatomic, readonly) CGFloat bottomOffset;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

- (void)setGame;
- (void)resetGame;
- (void)unloadGame;
- (void)gameDidAppear;

@end

