//
//  UIImage+ImageUtils.m
//  mtmvcore
//
//  Created by cwq on 16/11/19.
//  Copyright © 2016年 cwq. All rights reserved.
//

#import "UIImage+ImageUtils.h"

@implementation UIImage (ImageUtils)

void ProviderReleaseData(void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (UIImage *)imageAlphaPremultiplied:(UIImage *)image
{
    // 分配内存
    const size_t imageWidth = CGImageGetWidth(image.CGImage);
    const size_t imageHeight = CGImageGetHeight(image.CGImage);
    size_t bytesPerRow = imageWidth * 4;
    size_t imageBytes = bytesPerRow * imageHeight;
    unsigned char* rgbaImageBuf = (unsigned char*)malloc(imageBytes);
    memset(rgbaImageBuf, 0, imageBytes);
    
    // 创建context, CGImage转预乘的rgba
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbaImageBuf, imageWidth, imageHeight, 8, bytesPerRow,
                                                 colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsPushContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    UIGraphicsPopContext();
    CGContextRelease(context);
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbaImageBuf, imageBytes, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow,
                                        colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast,
                                        dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

@end
