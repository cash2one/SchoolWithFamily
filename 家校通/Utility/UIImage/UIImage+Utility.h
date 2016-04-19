//
//  UIImage+Utility.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CornerLeftTop = 0x1,
    CornerRightTop = 0x1 << 1,
    CornerLeftBottom = 0x1 << 2,
    CornerRightBottom = 0x1 << 3,
    CornerAll = (0x1 << 4) - 1,
}Corner;

#define DEFAULT_CORNER_RADIUS 6

#define TOP_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftTop|CornerRightTop radius:DEFAULT_CORNER_RADIUS])

#define BOTTOM_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftBottom|CornerRightBottom radius:DEFAULT_CORNER_RADIUS])

#define LEFT_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftBottom|CornerLeftTop radius:DEFAULT_CORNER_RADIUS])

#define RIGHT_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerRightTop|CornerRightBottom radius:DEFAULT_CORNER_RADIUS])

#define ALL_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerAll radius:DEFAULT_CORNER_RADIUS])

@interface UIImage (Utility)
+ (UIImage *)fastImageWithData:(NSData *)data;
+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path;
+ (UIImage *)drawImage1:(UIImage *)image1 rect1:(CGRect)rect1 image2:(UIImage *)image2 rect2:(CGRect)rect2;

+ (UIImage *)imageFromColor:(UIColor *)color
                     corner:(Corner)corner
                     radius:(CGFloat)radius;

@end
