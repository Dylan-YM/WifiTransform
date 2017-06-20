//
//  playController.h
//  WifiTransform
//
//  Created by yumiao on 2017/3/13.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LastVideoBlock)(NSString * fileName);
typedef void(^NextVideoBlock)(NSString * fileName);
@interface playController : UIViewController
@property (nonatomic, copy) NSString * videoName;
@property (nonatomic, strong) NSMutableDictionary * videoInfo;
@property (nonatomic, strong) NSMutableArray * videoInfoArr;
@property (nonatomic, strong) NSArray * fileList;
@end
