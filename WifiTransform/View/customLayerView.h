//
//  customLayerView.h
//  WifiTransform
//
//  Created by yumiao on 2017/3/14.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^LastVideoBlock)(NSString * fileName);
typedef void(^NextVideoBlock)(NSString * fileName);
@interface customLayerView : UIView
@property (nonatomic, copy) NSString * videoName;
@property (nonatomic, strong) NSMutableDictionary * videoInfo;
@property (nonatomic, copy) LastVideoBlock lastVideoBlock;
@property (nonatomic, copy) NextVideoBlock nextVideoBlock;

-(instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)superView;
@end
