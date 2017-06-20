//
//  VideoTableViewCell.h
//  WifiTransform
//
//  Created by yumiao on 2017/3/16.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton * iconBtn;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * sizeLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) NSDictionary * videoInfo;
@end
