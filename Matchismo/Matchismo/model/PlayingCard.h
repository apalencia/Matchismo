//
//  PlayingCard.h
//  Matchismo
//
//  Created by Angel Palencia on 29/01/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
