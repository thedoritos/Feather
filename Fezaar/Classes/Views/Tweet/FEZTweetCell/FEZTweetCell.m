//
//  FEZTweetCell.m
//  Fezaar
//
//  Created by t-matsumura on 3/22/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "FEZTweetCell.h"
#import "FEZDateFormatter.h"

@implementation FEZTweetCell

- (void)awakeFromNib
{
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = 8;
    self.userImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)presentTweet:(FEZTweet *)tweet
{
    self.creationDateLabel.text = [FEZDateFormatter formatDate:tweet.creationDate];
    
    self.userNameLabel.text = tweet.user.name;
    self.tweetTextLabel.text = tweet.text;
    [self.userImageView sd_setImageWithURL:[tweet.user profileImageURLWithType:FEZUserProfileImageTypeBigger]];
    
    self.favoriteCountLabel.text = [tweet.favoriteCount stringValue];
    self.retweetCountLabel.text = [tweet.retweetCount stringValue];
    
    [self layoutIfNeeded];
}

@end
