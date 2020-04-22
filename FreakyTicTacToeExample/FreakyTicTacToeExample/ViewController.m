//
//  ViewController.m
//  FreakyTicTacToeExample
//
//  Created by Enrico Angelini on 22/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "ViewController.h"
#import "TicTacToeGameView.h"

@interface ViewController () <GameViewDelegate>
@property (nonatomic, strong) TicTacToeGameView *gameView;
@end

@implementation ViewController

@synthesize priorityLevel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Game level
    self.priorityLevel = FAPriorityLevelVeryLow;
    
    // Game view
    self.gameView = [[TicTacToeGameView alloc] init];
    _gameView.delegate = self;
    [_gameView setGame];
    [self.view addSubview:self.gameView];
    
    self.view.backgroundColor = [UIColor orangeColor];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark -
#pragma mark GameViewDelegate protocol

- (void)manageGameResult:(BOOL)isCorrectResult
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Game Over", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Play", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.gameView setGame];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
