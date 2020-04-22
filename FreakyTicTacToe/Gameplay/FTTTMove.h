//
//  FTTTMove.h
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 13/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface FTTTMove : NSObject <GKGameModelUpdate>

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithIndex:(NSInteger)index;

@end
