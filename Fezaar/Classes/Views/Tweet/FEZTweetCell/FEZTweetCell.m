//
//  FEZTweetCell.m
//  Fezaar
//
//  Created by t-matsumura on 3/22/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <PocketAPI/PocketAPI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FEZTweetCell.h"
#import "FEZDateFormatter.h"

@interface FEZTweetCell ()

@property (nonatomic, copy, readonly) FEZTweet *tweet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (nonatomic) CGFloat imageViewDefaultHeight;

@end

@implementation FEZTweetCell

- (void)awakeFromNib
{
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = 8;
    self.userImageView.layer.masksToBounds = YES;
    
    self.mediaImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mediaImageView.clipsToBounds = YES;
    self.imageViewDefaultHeight = self.imageViewHeight.constant;
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
    
    self.pocketButton.enabled = [tweet containsURL];
    
    self.imageViewHeight.constant = [tweet containsMedia] ? self.imageViewDefaultHeight : 0;
    
    if ([tweet containsMedia]) {
        FEZMedia *media = tweet.entities.media.firstObject;
        [self.mediaImageView sd_setImageWithURL:media.mediaURL];
    } else {
        [self.mediaImageView sd_setImageWithURL:nil];
    }
    
    _tweet = tweet;
    [self layoutIfNeeded];
}

- (IBAction)saveToPocket:(id)sender
{
    if (![self.tweet containsURL]) {
        return;
    }
    
    NSURL *url = self.tweet.entities.urls.firstObject;
    
    [[PocketAPI sharedAPI] saveURL:url withTitle:self.tweet.text tweetID:[self.tweet.statusID stringValue] handler:^(PocketAPI *api, NSURL *url, NSError *error) {
        NSLog(@"Saved to Pocket url:%@, error:%@", url, error);
    }];
}

@end
