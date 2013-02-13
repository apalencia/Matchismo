//
//  Card.m
//  Matchismo
//
//  Created by Angel Palencia on 29/01/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

- (int)match:(NSArray *)otherCards;
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
