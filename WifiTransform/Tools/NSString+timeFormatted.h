//
//  NSString+timeFormatted.h
//  WifiTransform
//
//  Created by yumiao on 2017/4/20.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (timeFormatted)
+ (NSString *)timeFormatted:(NSInteger)totalSeconds;
+ (NSString *)FileSizeFormatted:(NSInteger)fileSize;
@end
