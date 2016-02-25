//
//  UIImage+Common.h
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (Common)

-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;

@end
