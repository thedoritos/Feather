//
//  FEZListCell.h
//  Fezaar
//
//  Created by t-matsumura on 4/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEZList.h"

@interface FEZListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *subscriberCountLabel;

- (void)presentList:(FEZList *)list;

@end
