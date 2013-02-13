//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Angel Palencia on 29/01/13.
//  Copyright (c) 2013 Angel Palencia. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeGameControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modeGameControl.hidden = NO;
    self.historySlider.hidden = YES;
    self.historySlider.minimumValue = 0.0;
    self.historySlider.value = 0.0;
}

#pragma mark - Target - Action

- (IBAction)historyGame:(UISlider *)sender {
    NSDictionary *stateDict = self.game.historyMatch[(int)sender.value];
    self.stateLabel.text = [self stateMatch:stateDict];
    self.stateLabel.alpha = (self.historySlider.value < self.historySlider.maximumValue) ? 0.3 : 1.0;
}

- (IBAction)modeGame:(UISegmentedControl *)sender
{
    self.game.modeGame = sender.selectedSegmentIndex + 2;
}

- (IBAction)deal:(UIButton *)sender {
    
    self.game = nil;
    self.modeGameControl.hidden = NO;
    self.historySlider.hidden = YES;
    self.historySlider.minimumValue = 0.0;
    self.stateLabel.alpha = 1.0;
    self.historySlider.value = 0.0;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.modeGameControl.hidden = YES;
    self.stateLabel.alpha = 1.0;
    self.historySlider.hidden = NO;
    [self updateUI];
}

#pragma mark - Accessors

- (UISegmentedControl *)modeGameControl
{
    _modeGameControl.selectedSegmentIndex = self.game.modeGame - 2;
    return _modeGameControl;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc]init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

#pragma mark - Synchronize Model with View

- (void)updateUI
{
    self.historySlider.maximumValue = [self.game.historyMatch count] - 1;
    self.historySlider.value = self.historySlider.maximumValue;
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        if (!card.isFaceUp) {
            UIImage *cardBack = [UIImage imageNamed:@"playing_card_back.jpg"];
            [cardButton setImageEdgeInsets:UIEdgeInsetsMake(-1.0,-1.0,-1.0,-1.0)];
            [cardButton setImage:cardBack forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
            
        }
        
    }
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.game.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    NSDictionary *stateDict = [self.game.historyMatch lastObject];
    self.stateLabel.text = [self stateMatch:stateDict];
}


-(NSString *)stateMatch:(NSDictionary *)stateDict
{
    NSString *stateLabel = @"";
    
    if (stateDict) {
        if ([[stateDict valueForKey:@"state"] isEqualToString:@"match"]) {
            stateLabel = [NSString stringWithFormat:@"Matched %@ for %d points",
                          [[stateDict valueForKey:@"cards"] componentsJoinedByString:@"&"],
                          [[stateDict valueForKey:@"bonus"] intValue]];
        } else if ([[stateDict valueForKey:@"state"] isEqualToString:@"mismatch"]) {
            stateLabel = [NSString stringWithFormat:@"%@ don't match! %d penalty",
                          [[stateDict valueForKey:@"cards"] componentsJoinedByString:@"&"],
                          [[stateDict valueForKey:@"bonus"] intValue]];
            
        } else if ([[stateDict valueForKey:@"state"] isEqualToString:@"flip"]) {
            stateLabel = [NSString stringWithFormat:@"Flipped up %@ with %d cost",
                          [[stateDict valueForKey:@"cards"] componentsJoinedByString:@""],
                          [[stateDict valueForKey:@"bonus"] intValue]];
        }
    }
    return stateLabel;
}

@end
