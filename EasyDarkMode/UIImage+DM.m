//
//  UIImage+DM.m
//  EasyInterface
//
//  Created by Elenion on 2019/8/5.
//  Copyright © 2019 Elenion. All rights reserved.
//

#import "UIImage+DM.h"
#import "DMManager.h"

@implementation UIImage (DM)

+ (UIImage *)dm_imageWithImageLight:(UIImage *)light dark:(UIImage *)dark {
    if (!light) {
        return nil;
    }
#if __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        // 如果没有暗色图片，直接返回亮色图片
        if (!dark) {
            return light;
        }
        
        // 获取当前的 trait collection
        UITraitCollection *const scaleTraitCollection = [UITraitCollection currentTraitCollection];
        
        // 创建亮色和暗色的 trait collection
        UITraitCollection *const lightTraitCollection = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight];
        UITraitCollection *const darkUnscaledTraitCollection = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];
        UITraitCollection *const darkScaledTraitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:@[scaleTraitCollection, darkUnscaledTraitCollection]];
        UITraitCollection *const lightScaledTraitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:@[scaleTraitCollection, lightTraitCollection]];
        
        // 创建一个新的 UIImageAsset
        UIImageAsset *imageAsset = [[UIImageAsset alloc] init];
        
        // 注册亮色图片
        [imageAsset registerImage:light withTraitCollection:lightScaledTraitCollection];
        
        // 注册暗色图片
        [imageAsset registerImage:dark withTraitCollection:darkScaledTraitCollection];
        
        // 根据当前的 trait collection 获取对应的图片
        UIImage *resultImage = [imageAsset imageWithTraitCollection:scaleTraitCollection];
        
        // 如果获取失败，尝试直接根据当前模式返回
        if (!resultImage) {
            if (scaleTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                resultImage = dark;
            } else {
                resultImage = light;
            }
        }
        
        return resultImage;
    } else {
#endif
        switch (DMManager.shared.interfaceStyleForLowerSystem) {
            case DMUserInterfaceStyleDark:
                return dark ? dark : light;
            case DMUserInterfaceStyleLight:
            case DMUserInterfaceStyleUnspecified:
            default:
                return light;
        }
#if __IPHONE_13_0
    }
#endif
}

+ (UIImage *)dm_imageWithNameLight:(NSString *)light dark:(NSString *)dark {
    UIImage *lightImage = [UIImage imageNamed:light];
    if (!lightImage) {
        return nil;
    }
    UIImage *darkImage = [UIImage imageNamed:dark];
    return [self dm_imageWithImageLight:lightImage dark:darkImage];
}

@end
