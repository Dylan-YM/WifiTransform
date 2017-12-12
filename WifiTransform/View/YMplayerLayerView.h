//
//  YMplayerLayerView.h
//  WifiTransform
//
//  Created by yumiao on 2017/12/11.
//  Copyright © 2017年 richard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    doneBtnClickType,
    infoBtnClickType,
    frontBtnClickType,
    playBtnClickType,
    backBtnClickType,
    fullScreenBtnClickType
} btnClickType;


typedef void (^btnClick)(NSInteger tag);
typedef void (^sliderMove)(CGFloat value);
@interface YMplayerLayerView : UIView
@property (nonatomic, copy) btnClick btnClick;
@property (nonatomic, copy) sliderMove sliderMove;
@property (weak, nonatomic) IBOutlet UISlider *moveSlider;
@property (weak, nonatomic) IBOutlet UILabel *minSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSliderLabel;

@end
