//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Angel Palencia on 01/02/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import "CardMatchingGame.h"

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) NSMutableArray *historyMatch;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int flipCount;
@end

@implementation CardMatchingGame

#pragma mark - Accesors

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)historyMatch
{
    if (!_historyMatch) _historyMatch = [NSMutableArray array];
    return _historyMatch;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
}

- (int)modeGame
{
    if (_modeGame == 0) _modeGame = MODE_GAME_2CARDS;
    return _modeGame;
}

#pragma mark - API methods

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card){
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = self.cards[index];
    NSString *state = @"";
    int bonus;
    self.flipCount++;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            
            state = @"flip";
            bonus = FLIP_COST;
            NSMutableArray *otherCards = [NSMutableArray array];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    
                    if ([otherCards count] == self.modeGame - 1) {
                        int matchScore = [card match:otherCards];
                        if (matchScore) {
                            for (Card *matchCard in otherCards) {
                                matchCard.unplayable = YES;
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            state = @"match";
                            bonus = MATCH_BONUS;
                            
                        } else {
                            for (Card *matchCard in otherCards) {
                                matchCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            state = @"mismatch";
                            bonus = MISMATCH_PENALTY;
                        }
                    }
                }
            }
            self.score -= FLIP_COST;
            [otherCards insertObject:card atIndex:0];
            NSDictionary *stateMatch = @{@"state" : state,
                                          @"cards" : otherCards,
                                          @"bonus" : @(bonus)};
            [self.historyMatch addObject:stateMatch];
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
