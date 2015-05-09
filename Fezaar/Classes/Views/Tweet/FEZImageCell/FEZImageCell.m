//
//  FEZImageCell.m
//  Fezaar
//
//  Created by t-matsumura on 5/3/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "FEZImageCell.h"

@interface FEZImageCell ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (nonatomic) FEZTweet *tweet;

@end

@implementation FEZImageCell

- (void)awakeFromNib
{
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageButton.imageView.clipsToBounds = YES;
}

- (void)setTweet:(FEZTweet *)tweet
{
    _tweet = tweet;
    
    if ([tweet containsMedia]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        FEZMedia *media = tweet.entities.media.firstObject;
        [manager downloadImageWithURL:media.mediaURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [self.imageButton setImage:image forState:UIControlStateNormal];
        }];
    }
    
    self.tweetTextLabel.text = tweet.text;
}

- (IBAction)showImage:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FEZNotificationShowMedia" object:nil userInfo:@{@"tweet" : self.tweet}];
}

@end
