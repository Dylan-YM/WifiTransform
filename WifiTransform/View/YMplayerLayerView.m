//
//  YMplayerLayerView.m
//  WifiTransform
//
//  Created by yumiao on 2017/12/11.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "YMplayerLayerView.h"

@interface YMplayerLayerView ()
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;


@end
@implementation YMplayerLayerView


- (IBAction)playBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
- (IBAction)DoneBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
- (IBAction)MoveSlider:(UISlider *)sender {
 
    if (self.sliderMove) {
        self.sliderMove(sender.value);
    }
}
- (IBAction)infoBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
- (IBAction)frontBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
- (IBAction)fullScreenClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}

@end
