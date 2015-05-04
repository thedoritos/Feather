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

@property (nonatomic) CGFloat imageButtonDefaultHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageButtonHeight;

@property (nonatomic) NSString *retweetUserLabelFormat;

@end

@implementation FEZTweetCell

- (void)awakeFromNib
{
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = 8;
    self.userImageView.layer.masksToBounds = YES;
    
    self.mediaImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mediaImageButton.imageView.clipsToBounds = YES;
    self.imageButtonDefaultHeight = self.mediaImageButton.frame.size.height;
    
    self.retweetUserLabelFormat = self.retweetUserLabel.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)presentTweet:(FEZTweet *)tweet
{
    _tweet = tweet;

    if ([tweet isRetweet]) {
        self.retweetUserLabel.text = [NSString stringWithFormat:self.retweetUserLabelFormat, tweet.user.name];
        tweet = tweet.retweetedStatus;
    } else {
        self.retweetUserLabel.text = nil;
    }
    
    self.creationDateLabel.text = [FEZDateFormatter formatDate:tweet.creationDate];
    
    self.userNameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.tweetTextLabel.text = tweet.text;
    [self.userImageView sd_setImageWithURL:[tweet.user profileImageURLWithType:FEZUserProfileImageTypeBigger]];
    
    self.favoriteCountLabel.text = [tweet.favoriteCount stringValue];
    self.retweetCountLabel.text = [tweet.retweetCount stringValue];
    
    self.pocketButton.enabled = [tweet containsURL];
    
    self.imageButtonHeight.constant = [tweet containsMedia] ? self.imageButtonDefaultHeight: 0;
    if ([tweet containsMedia]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        FEZMedia *media = tweet.entities.media.firstObject;
        [manager downloadImageWithURL:media.mediaURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [self.mediaImageButton setImage:image forState:UIControlStateNormal];
        }];
    }
    
    [self layoutIfNeeded];
}

- (IBAction)presentMedia:(id)sender
{
    if (![self.tweet containsMedia]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FEZNotificationShowMedia" object:nil userInfo:@{@"tweet" : self.tweet}];
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
