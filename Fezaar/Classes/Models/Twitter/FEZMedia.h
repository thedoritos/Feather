//
//  FEZMedia.h
//  Fezaar
//
//  Created by t-matsumura on 4/28/15.
//  Copyright (c) 2015 HumourStudio. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <NYTPhotoViewer/NYTPhoto.h>

@interface FEZMedia : MTLModel <MTLJSONSerializing, NYTPhoto>

@property (nonatomic, copy, readonly) NSNumber *mediaID;

@property (nonatomic, copy, readonly) NSURL *mediaURL;

#pragma mark - NYPhoto

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIImage *placeholderImage;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionCredit;

@end
