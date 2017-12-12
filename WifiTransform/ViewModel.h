//
//  ViewModel.h
//  WifiTransform
//
//  Created by yumiao on 2017/12/8.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject
- (NSArray *)getVideoList;
+ (instancetype)ShareInstance;
- (NSString *)getIPAddress;
@end
