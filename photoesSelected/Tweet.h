//
//  Tweet.h
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TweetImage;

@interface Tweet : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray *tweetImages;//对 selectedAssetURLs 操作即可，最好不要直接赋值。。应用跳转带的图片会直接对 tweetImages赋值
@property (readwrite, nonatomic, strong) NSMutableArray *selectedAssetURLs;

- (void)addASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteATweetImage:(TweetImage *)tweetImage;
- (NSMutableArray *)addSelectAssetUrl:(NSMutableArray *)selectedAsseURL;
@end


typedef NS_ENUM(NSInteger, TweetImageUploadState)
{
    TweetImageUploadStateInit = 0,
    TweetImageUploadStateIng,
    TweetImageUploadStateSuccess,
    TweetImageUploadStateFail
};

@interface TweetImage : NSObject
@property (readwrite, nonatomic, strong) UIImage *image, *thumbnailImage;
@property (strong, nonatomic) NSURL *assetURL;
@property (assign, nonatomic) TweetImageUploadState uploadState;
@property (readwrite, nonatomic, strong) NSString *imageStr;
+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL;
+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image;
@end
