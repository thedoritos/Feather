//
//  FEZTweetCell.m
//  Fezaar
//
//  Created by t-matsumura on 3/22/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZTweetCell.h"

@implementation FEZTweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)presentTweet:(FEZTweet *)tweet
{
    self.userNameLabel.text = tweet.user.name;
    self.tweetTextLabel.text = tweet.text;
}

@end
