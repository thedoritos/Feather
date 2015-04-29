//
//  FEZTweetCell.h
//  Fezaar
//
//  Created by t-matsumura on 3/22/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEZTweet.h"

@interface FEZTweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *retweetUserLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;

@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *pocketButton;

- (void)presentTweet:(FEZTweet *)tweet;

@end
