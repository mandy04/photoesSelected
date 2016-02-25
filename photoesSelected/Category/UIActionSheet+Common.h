//
//  UIActionSheet+Common.h
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Common)

+ (instancetype)bk_actionSheetCustomWithTitle:(NSString *)title
                                 buttonTitles:(NSArray *)buttonTitles
                             destructiveTitle:(NSString *)destructiveTitle
                                  cancelTitle:(NSString *)cancelTitle
                           andDidDismissBlock:(void (^)(UIActionSheet *sheet,NSInteger index))block;
@end
