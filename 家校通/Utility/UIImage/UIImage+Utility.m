//
//  UIImage+Utility.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

+ (UIImage *)decode:(UIImage *)image {
    if(image == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(image.size);
    
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)fastImageWithData:(NSData *)data {
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}

+ (UIImage *)drawImage1:(UIImage *)image1 rect1:(CGRect)rect1 image2:(UIImage *)image2 rect2:(CGRect)rect2
{
    UIGraphicsBeginImageContext(rect1.size);
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

+ (UIImage *)imageFromColor:(UIColor *)color corner:(Corner)corner radius:(CGFloat)radius
{
    CGFloat width = MAX(10, radius * 2+2);
    UIImage *image = nil;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGFloat height = width;
    [color setFill];
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    if (corner&CornerLeftTop) {
        CGContextMoveToPoint(context, radius, 0);
    }else{
        CGContextMoveToPoint(context, 0, 0);
    }
    
    if (corner&CornerRightTop) {
        // 绘制第1条线和第1个1/4圆弧
        CGContextAddLineToPoint(context, width - radius, 0);
        CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    }else{
        CGContextAddLineToPoint(context, width, 0);
    }
    
    if (corner & CornerRightBottom) {
        // 绘制第2条线和第2个1/4圆弧
        CGContextAddLineToPoint(context, width, height - radius);
        CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, width, height);
    }
    
    if (corner&CornerLeftBottom) {
        // 绘制第3条线和第3个1/4圆弧
        CGContextAddLineToPoint(context, radius, height);
        CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, 0, height);
    }
    
    if (corner&CornerLeftTop) {
        // 绘制第4条线和第4个1/4圆弧
        CGContextAddLineToPoint(context, 0, radius);
        CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, 0, 0);
    }
    
    // 闭合路径
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:width/2 topCapHeight:width/2];
}

@end
