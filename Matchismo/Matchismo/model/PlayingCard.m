//
//  PlayingCard.m
//  Matchismo
//
//  Created by Angel Palencia on 29/01/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

// recursive method
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    NSMutableArray *otherPlayingCards = [otherCards mutableCopy];
    id otherCard = [otherPlayingCards lastObject];
    if (otherCard) [otherPlayingCards removeLastObject];
    
    if ([otherCard isKindOfClass:[PlayingCard class]]) {
        PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
        
        if ([otherPlayingCard.suit isEqualToString:self.suit]) {
            score += 1;
        } else if (otherPlayingCard.rank == self.rank) {
            score += 4;
        } else {
        }
        score += [self match:otherPlayingCards] + [otherPlayingCard match:otherPlayingCards];
    }
    return score;
}

- (NSString *)contents
{
      return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits]containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)description
{
    return self.contents;
}

@end
