//
//  Tweet.m
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import "Tweet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSObject+Common.h"
#import "UIImage+Common.h"

@implementation Tweet


- (NSMutableArray *)addSelectAssetUrl:(NSMutableArray *)selectedAsseURL {
    
    _tweetImages = [NSMutableArray arrayWithCapacity:0];
    [selectedAsseURL enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSURL *assetURL = obj;
        TweetImage *tweetImg = [TweetImage tweetImageWithAssetURL:assetURL];
        [_tweetImages addObject:tweetImg];
    }];
    return _tweetImages;
}


- (void)addASelectedAssetURL:(NSURL *)assetURL{
    if (!_selectedAssetURLs) {
        _selectedAssetURLs = [NSMutableArray new];
    }
    if (!_tweetImages) {
        _tweetImages = [NSMutableArray new];
    }
    
    [_selectedAssetURLs addObject:assetURL];
    
    NSMutableArray *tweetImages = [self mutableArrayValueForKey:@"tweetImages"];//为了kvo
    TweetImage *tweetImg = [TweetImage tweetImageWithAssetURL:assetURL];
    [tweetImages addObject:tweetImg];
}

- (void)deleteASelectedAssetURL:(NSURL *)assetURL{
    [self.selectedAssetURLs removeObject:assetURL];
    NSMutableArray *tweetImages = [self mutableArrayValueForKey:@"tweetImages"];//为了kvo
    [tweetImages enumerateObjectsUsingBlock:^(TweetImage *obj, NSUInteger idx, BOOL *stop) {
        if (obj.assetURL == assetURL) {
            [tweetImages removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void)deleteATweetImage:(TweetImage *)tweetImage{
    NSMutableArray *tweetImages = [self mutableArrayValueForKey:@"tweetImages"];//为了kvo
    [tweetImages removeObject:tweetImage];
    if (tweetImage.assetURL) {
        [self.selectedAssetURLs removeObject:tweetImage.assetURL];
    }
}

@end


@implementation TweetImage
+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL{
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.uploadState = TweetImageUploadStateInit;
    tweetImg.assetURL = assetURL;
    
    void (^selectAsset)(ALAsset *) = ^(ALAsset *asset){
        if (asset) {
            UIImage *highQualityImage = [UIImage fullScreenImageALAsset:asset];
            UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
            dispatch_async(dispatch_get_main_queue(), ^{
                tweetImg.image = highQualityImage;
                tweetImg.thumbnailImage = thumbnailImage;
            });
        }
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    @weakify(assetsLibrary);
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            selectAsset(asset);
        }else{
            @strongify(assetsLibrary);
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stopG) {
                    if([result.defaultRepresentation.url isEqual:assetURL]) {
                        selectAsset(result);
                        *stop = YES;
                        *stopG = YES;
                    }
                }];
            } failureBlock:^(NSError *error) {
                [NSObject showHudTipStr:@"读取图片失败"];
            }];
        }
    }failureBlock:^(NSError *error) {
        [NSObject showHudTipStr:@"读取图片失败"];
    }];
    return tweetImg;
    
}

+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image{
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.uploadState = TweetImageUploadStateInit;
    tweetImg.assetURL = assetURL;
    tweetImg.image = image;
    tweetImg.thumbnailImage = [image scaledToSize:CGSizeMake(kScaleFrom_iPhone5_Desgin(70), kScaleFrom_iPhone5_Desgin(70)) highQuality:YES];
    return tweetImg;
}


@end
