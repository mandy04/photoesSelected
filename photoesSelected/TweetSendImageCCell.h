//
//  TweetSendImageCCell.h
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#define kCCellIdentifier_TweetSendImage @"TweetSendImageCCell"

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetSendImageCCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) TweetImage *curTweetImg;
@property (copy, nonatomic) void (^deleteTweetImageBlock)(TweetImage *toDelete);
+(CGSize)ccellSize;
@end
