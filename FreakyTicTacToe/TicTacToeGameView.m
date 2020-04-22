//
//  TicTacToeGameView.m
//  FreakyTicTacToe
//
//  Created by Enrico Angelini on 15/04/2020.
//  Copyright © 2020 Spirales di Enrico Angelini. All rights reserved.
//

#import "TicTacToeGameView.h"
#import "FTTTBoard.h"

#define kLineWidth 4.0f
#define kMinimumBoardHorizontalMargin 60.0f

@interface TicTacToeGameView ()
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger marks;
@property (nonatomic, assign) FTTTMark firstMark;
@property (nonatomic, assign) NSInteger maxLookAheadDepth;
@property (nonatomic, assign) BOOL globalViewContentsCreated;
@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, strong) FTTTBoard *board;
@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) NSMutableArray<FTTTControl *> *cells;
@property (nonatomic, strong) GKMinmaxStrategist *strategist;
@property (nonatomic, strong) UILabel *turnLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) NSTimeInterval userMoveTime;
@end

@implementation TicTacToeGameView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.cellSize = 60.0;
    }
    return self;
}


- (void)createGlobalViewContents
{
    // Set game settings
    [self configureSettings];
    
    // Minmax strategist
    self.strategist = [[GKMinmaxStrategist alloc] init];
    _strategist.maxLookAheadDepth = self.maxLookAheadDepth;
    
    // Title text
    NSString *marksString = [NSString stringWithFormat:NSLocalizedString(@"tictactoeMarks", nil), self.marks];
    NSAttributedString *marksAttributedString = [[NSAttributedString alloc] initWithString:marksString attributes:@{NSFontAttributeName:DemiboldFont(18)}];
    // Title attributed text
    NSString *titleString = NSLocalizedString(@"tictactoeGameTitleKey", nil);
    NSRange range = [titleString rangeOfString:@"%@"];
    NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:GameFont(18.0f)}];
    [titleAttributedText replaceCharactersInRange:range withAttributedString:marksAttributedString];

    // Label of title
    CGSize titleSize = [titleAttributedText size];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, self.topOffset + 17.0f, self.width - 10.0f, titleSize.height)];
    [titleLabel setAttributedText:titleAttributedText];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor: [UIColor clearColor]];
    [titleLabel setMinimumScaleFactor:16.0f/18.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    
    // Sizes
    self.cellSize = roundf((self.width - (kMinimumBoardHorizontalMargin * 2) - ((self.size - 1) * kLineWidth)) / self.size);
    CGFloat lineHeight = (self.cellSize * self.size) + ((self.size - 1) * kLineWidth);
    CGFloat step = self.cellSize + kLineWidth;
    CGFloat baseX = (self.width - (self.cellSize * self.size) - ((self.size - 1) * kLineWidth)) / 2;
    CGFloat baseY = [self center].y - lineHeight / 2;
    //NSLog(@"CellSize:%f BaseX:%f", self.cellSize, baseX);
    
    // Lines
    for (NSInteger i=1; i <= (self.size - 1); i++)
    {
        // Vertical line
        UIView *vLineView = [[UIView alloc] initWithFrame:CGRectMake(baseX + (self.cellSize * i) + (kLineWidth * (i - 1)), baseY, kLineWidth, lineHeight)];
        vLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:vLineView];
        
        // Horizontal line
        UIView *hLineView = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY + (self.cellSize * i) + (kLineWidth * (i - 1)), lineHeight, kLineWidth)];
        hLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:hLineView];
    }
    
    // Board background view
    self.boardView = [[UIView alloc] initWithFrame:CGRectMake(baseX, baseY, step * self.size, step * self.size)];
    [self addSubview:self.boardView];
    
    // Turn label
    CGFloat turnLabelHeight = 60.0;
    CGFloat turnLabelY = self.boardView.frame.origin.y + self.boardView.frame.size.height + ((self.height - self.bottomOffset - self.boardView.frame.origin.y - self.boardView.frame.size.height) / 2) - (turnLabelHeight / 2);
    UILabel *turnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, turnLabelY, self.width, turnLabelHeight)];
    turnLabel.textColor = [UIColor whiteColor];
    turnLabel.backgroundColor = [UIColor clearColor];
    turnLabel.font = GameWideFont(30.0);
    turnLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:turnLabel];
    self.turnLabel = turnLabel;
    
    // Activity indicatori view
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = self.turnLabel.center;
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
    
    // Control variable
    self.globalViewContentsCreated = YES;
}


- (CGPoint)center
{
    return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
}



#pragma mark -
#pragma mark Game generation

- (void)setGame
{
    if (!self.globalViewContentsCreated)
    {
        // Create global UI just once
        [self createGlobalViewContents];
    }
    else
    {
        // Reset previous game
        [self resetGame];
    }
    
    // Create game UI
    [self createGameViewContents];
}


- (void)resetGame
{
    // Remove all board subviews
    for (UIView *view in [self.boardView subviews])
    {
        [view removeFromSuperview];
    }
    self.turnLabel.text = @"";
    [self.activityIndicatorView stopAnimating];
}


- (void)createGameViewContents
{
    // Board
    self.board = [[FTTTBoard alloc] initWithSize:self.size marks:self.marks firstMark:self.firstMark];
    self.strategist.gameModel = self.board;
        
    // Cells
    self.cells = [[NSMutableArray alloc] initWithCapacity:[[self.board cells] count]];
    for (NSInteger i=0; i < [[self.board cells] count]; i++)
    {
        CGFloat x = floorf((CGFloat)i / (CGFloat)self.size) * (self.cellSize + kLineWidth);
        CGFloat y = (CGFloat)(self.size - 1 - (i % self.size)) * (self.cellSize + kLineWidth);
        //NSLog(@"X:%f - Y:%f", x, y);
        FTTTControl *cell = [[FTTTControl alloc] initWithFrame:CGRectMake(x, y, self.cellSize, self.cellSize)];
        [cell addTarget:self action:@selector(cellDidTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.boardView addSubview:cell];
        [self.cells addObject:cell];
    }
    
    // Turn label text
    self.turnLabel.text = (self.firstMark == FTTTMarkO ? @"" : NSLocalizedString(@"tictactoeTurnYou", nil));
    
    // The first move is played by bot
    if (self.firstMark == FTTTMarkO)
    {
        // Find a move
        [self performSelectorInBackground:@selector(findBotMove) withObject:nil];
        // Start activity indicator
        [self.activityIndicatorView startAnimating];
    }
}


- (void)unloadGame
{
}


- (void)configureSettings
{
    switch (self.delegate.priorityLevel)
    {
        case FAPriorityLevelVeryHigh:
            self.size = 5;
            self.marks = 4;
            self.firstMark = FTTTMarkO;
            self.maxLookAheadDepth = 4;
            break;
            
        case FAPriorityLevelHigh:
            self.size = 5;
            self.marks = 4;
            self.firstMark = FTTTMarkX;
            self.maxLookAheadDepth = 4;
            break;
            
        case FAPriorityLevelMedium:
            self.size = 3;
            self.marks = 3;
            self.firstMark = FTTTMarkO;
            self.maxLookAheadDepth = 5;
            break;
            
        default:
            self.size = 3;
            self.marks = 3;
            self.firstMark = FTTTMarkX;
            self.maxLookAheadDepth = 5;
            break;
    }
}



#pragma mark -
#pragma mark Tic-tac-toe logic

- (void)updateBoard
{
    [self.board.cells enumerateObjectsUsingBlock:^(NSNumber *cell, NSUInteger index, BOOL *stop)
    {
        FTTTControl *control = [self.cells objectAtIndex:index];
        FTTTMark mark = (FTTTMark)[cell integerValue];
        if (mark != FTTTMarkNone)
        {
            control.mark = mark;
        }
    }];

    // Game is over
    if ([self.board isGameOver])
    {
        BOOL result = YES;
        NSString *message;
        
        // Win
        if ([self.board isWinForPlayer:[FTTTPlayer xPlayer]])
        {
            message = NSLocalizedString(@"tictactoeWon", nil);
        }
        // Lost
        else if ([self.board isWinForPlayer:[FTTTPlayer oPlayer]])
        {
            result = NO;
            message = NSLocalizedString(@"tictactoeLost", nil);
        }
        // Draw
        else
        {
            message = NSLocalizedString(@"tictactoeDraw", nil);
        }
        
        // Update label text
        self.turnLabel.text = message;
        // Stop activity indicator
        [self.activityIndicatorView stopAnimating];
        
        // Call delegate
        if (self.delegate != nil)
        {
            [self.delegate manageGameResult:result];
        }
    }
    // Game in progress
    else
    {
        // Current player
        FTTTMark mark = [self.board currentPlayer].mark;
        if (mark == FTTTMarkX)
        {
            // It's user turn, so show a hint and stop activity indicator
            self.turnLabel.text = NSLocalizedString(@"tictactoeTurnYou", nil);
            [self.activityIndicatorView stopAnimating];
        }
        else if (mark == FTTTMarkO)
        {
            // It's bot turn, so start activity indicator
            self.turnLabel.text = @"";
            [self.activityIndicatorView startAnimating];
        }
    }
}


- (void)cellDidTouched:(id)sender
{
    // Move played by user
    if ([self.board currentPlayer].mark == FTTTMarkX)
    {
        FTTTControl *cell = (FTTTControl *)sender;
        if (cell != nil)
        {
            NSUInteger index = [self.cells indexOfObject:cell];
            //NSLog(@"cellDidTouched index %lu", (unsigned long)index);
            if (index >= 0 && index < [self.board.cells count])
            {
                FTTTMark mark = (FTTTMark)[[self.board.cells objectAtIndex:index] integerValue];
                if (mark == FTTTMarkNone)
                {
                    // Update board with user move
                    [self.board updateCell:index];
                    [self updateBoard];
                    self.userMoveTime = [[NSDate date] timeIntervalSince1970];
                    
                    // Find a move
                    [self performSelectorInBackground:@selector(findBotMove) withObject:nil];
                }
            }
        }
    }
}


- (void)findBotMove
{
    FTTTMove *move = [self.strategist bestMoveForPlayer:[self.board currentPlayer]];
    if (move != nil)
    {
        // Update board with bot move
        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSince1970] - self.userMoveTime;
        if (deltaTime > 0.8)
        {
            // Apply the move immediately
            [self performSelectorOnMainThread:@selector(applyBotMove:) withObject:move waitUntilDone:NO];
        }
        else
        {
            // Wait a while and then apply the move
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.8 - deltaTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self applyBotMove:move];
            });
        }
    }
}


- (void)applyBotMove:(FTTTMove *)move
{
    [self.board applyGameModelUpdate:move];
    [self updateBoard];
}

@end
