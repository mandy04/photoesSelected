//
//  TweetSendImagesCell.h
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

#define kCellIdentifier_TweetSendImages @"TweetSendImagesCell"

@interface TweetSendImagesCell : UITableViewCell

@property (strong, nonatomic) Tweet *curTweet;
@property (copy, nonatomic) void(^addPicturesBlock)();
@property (copy, nonatomic) void (^deleteTweetImageBlock)(TweetImage *toDelete);

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
