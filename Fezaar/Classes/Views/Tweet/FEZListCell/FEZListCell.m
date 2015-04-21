//
//  FEZListCell.m
//  Fezaar
//
//  Created by t-matsumura on 4/21/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import "FEZListCell.h"

@implementation FEZListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected: selected animated:animated];

    // Configure the view for the selected state
}

- (void)presentList:(FEZList *)list
{
    self.nameLabel.text = list.name;
    self.descriptionLabel.text = list.listDescription;
    
    self.memberCountLabel.text = [list.memberCount stringValue];
    self.subscriberCountLabel.text = [list.subscriberCount stringValue];
}

@end
