//
//  NSString+timeFormatted.m
//  WifiTransform
//
//  Created by yumiao on 2017/4/20.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "NSString+timeFormatted.h"

@implementation NSString (timeFormatted)
// 文件时间转时长
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%2zd:%02zd:%02zd",hours, minutes, seconds];
}

+ (NSString *)FileSizeFormatted:(NSInteger)fileSize{
    if ((double)(fileSize / 10000000) > 1) {
        return [NSString stringWithFormat:@"%.03fG",(float)fileSize/1000000000];
    }else if ((double)(fileSize / 10000) > 1){
        return [NSString stringWithFormat:@"%.03fM",(double)fileSize/10000000];
    }else{
        return [NSString stringWithFormat:@"%.03fkb",(double)(fileSize/10000)];
    }
}
@end
