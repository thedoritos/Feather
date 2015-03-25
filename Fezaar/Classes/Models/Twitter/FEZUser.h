//
//  FEZUser.h
//  Fezaar
//
//  Created by t-matsumura on 3/23/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, FEZUserProfileImageType)
{
    FEZUserProfileImageTypeNormal,
    FEZUserProfileImageTypeBigger,
    FEZUserProfileImageTypeMini,
    FEZUserProfileImageTypeOriginal
};

@interface FEZUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *userID;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *screenName;

@property (nonatomic, copy, readonly) NSURL *profileImageURL;

- (NSURL *)profileImageURLWithType:(FEZUserProfileImageType)type;

@end
