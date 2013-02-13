//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Angel Palencia on 01/02/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

#define MODE_GAME_2CARDS 2
#define MODE_GAME_3CARDS 3

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int flipCount;
@property (nonatomic) int modeGame;
@property (nonatomic, readonly) NSMutableArray *historyMatch; // of dictionary with state of match
// Key "state" with NSString value: "match", "mismatch" or "flip"
// Key "cards" array of cards
// key "bonus" with  NSNumber value: MATCH_BONUS, MISMATCH_PENALTY, FLIP_COST

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
