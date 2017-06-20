//
//  customLayerView.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/14.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "customLayerView.h"
#import "UIView+SFLayout.h"
#import "NSString+timeFormatted.h"
@interface customLayerView ()
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) AVPlayerItem * playerItem;

// 遮盖版
@property (nonatomic, strong) UIView * coverView;
// 背景图片
@property (nonatomic, strong) UIImageView * backImageView;
// 播放按钮
@property (nonatomic, strong) UIButton * playBtn;
// 下一个
@property (nonatomic, strong) UIButton * nextBtn;
// 上一个
@property (nonatomic, strong) UIButton * lastBtn;
// 全屏
@property (nonatomic, strong) UIButton * fullScreenBtn;
// 进度条
@property (nonatomic, strong) UISlider  * slider;
// 全部时间
@property (nonatomic, strong) UILabel * allTime;
// 现在时间
@property (nonatomic, strong) UILabel * nowTime;

@property (nonatomic, assign) NSInteger allTimeNum;
/**slider定时器*/
@property (nonatomic,strong) NSTimer          *sliderTimer;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) UIView * superView;
@end
@implementation customLayerView


- (instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlayer];
        _isFullScreen = NO;
        _superView = superView;
    }
    return self;
}


- (void)setupPlayer{
    self.backgroundColor = [UIColor whiteColor];
    self.player = [[AVPlayer alloc]init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //开启
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self setupImageView];
    [self btnClickWithPlayAndPause];
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.playerLayer.frame = self.backImageView.bounds;
    if (self.isFullScreen) {
         self.slider.frame = CGRectMake(0, CGRectGetHeight(self.backImageView.frame) - 100, CGRectGetWidth(self.bounds), 10);
        self.playBtn.frame = CGRectMake(8, CGRectGetMaxY(self.slider.frame) + 9, 50, 50);
        self.lastBtn.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 50, self.playBtn.y, 50, 50);
        self.nextBtn.frame = CGRectMake(CGRectGetMaxX(self.lastBtn.frame) + 50, self.playBtn.y, 50, 50);
        CGSize nowTimeSize = self.nowTime.size;
        CGSize allTimeSize = self.allTime.size;
        self.nowTime.frame = CGRectMake(CGRectGetMaxX(self.nextBtn.frame) + 80, self.nextBtn.y, nowTimeSize.width, 50);
        self.allTime.frame = CGRectMake(CGRectGetMaxX(self.nowTime.frame) + 50, self.nextBtn.y, allTimeSize.width, 50);
           self.fullScreenBtn.frame = CGRectMake(CGRectGetMaxX(self.allTime.frame) + 50, self.playBtn.y, 50, 50);
    }else{
        self.backImageView.frame = self.bounds;
        self.coverView.frame = self.bounds;
        self.slider.frame = CGRectMake(0, CGRectGetHeight(self.backImageView.frame) - 100, CGRectGetWidth(self.bounds), 10);
        self.playBtn.frame = CGRectMake(8, CGRectGetMaxY(self.slider.frame) + 9, 24, 24);
        self.lastBtn.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 24, self.playBtn.y, 24, 24);
        self.nextBtn.frame = CGRectMake(CGRectGetMaxX(self.lastBtn.frame) + 24, self.playBtn.y, 24, 24);
        CGSize nowTimeSize = self.nowTime.size;
        CGSize allTimeSize = self.allTime.size;
        self.nowTime.frame = CGRectMake(CGRectGetMaxX(self.nextBtn.frame) + 80, self.nextBtn.y, nowTimeSize.width, 24);
        self.allTime.frame = CGRectMake(CGRectGetMaxX(self.nowTime.frame) + 24, self.nextBtn.y, allTimeSize.width, 24);
        self.fullScreenBtn.frame = CGRectMake(CGRectGetMaxX(self.allTime.frame) + 24, self.playBtn.y, 24, 24);
    }
    
}
- (void)setVideoName:(NSString *)videoName{
    _videoName = videoName;
}
// imageView上添加playerLayer
- (void)setupImageView{

        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.frame = self.bounds;
        [self.backImageView.layer addSublayer:self.playerLayer];
        self.backImageView.layer.borderColor = [UIColor blackColor].CGColor;
        self.backImageView.layer.borderWidth = 0.5;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewShowOrHide)];
        [self.backImageView addGestureRecognizer:tap];
        
        [self addSubview:self.backImageView];
        
        self.coverView = [[UIView alloc]init];
        self.coverView.userInteractionEnabled = YES;
        self.coverView.hidden = YES;
        self.coverView.frame = self.bounds;
        self.coverView.backgroundColor = [UIColor blackColor];
        self.coverView.alpha = 0.5;
        UITapGestureRecognizer * covtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewShowOrHide)];
        [self.coverView addGestureRecognizer:covtap];
        [self.backImageView addSubview:self.coverView];
        
        
        // 设置Slider
        self.slider = [[UISlider alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.backImageView.frame) - 100, CGRectGetWidth(self.bounds), 10)];
        self.slider.maximumValue = 1;
        self.slider.minimumValue = 0;
        
        [self.coverView addSubview:self.slider];
        [self.slider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        [self.slider addTarget:self action:@selector(moveTheSlider:) forControlEvents:UIControlEventValueChanged];
        [self.slider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
        // 社会播放按钮
        self.playBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(self.slider.frame) + 9, 24, 24)];
        self.playBtn.tag = 1001;
        
        [self.playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.coverView addSubview:self.playBtn];
        [self.playBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateSelected];
        self.playBtn.selected = YES;
        
        
        self.lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 24, self.playBtn.y, 24, 24)];
        self.lastBtn.tag = 1002;
        [self.lastBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.lastBtn setImage:[UIImage imageNamed:@"lastVideo"] forState:UIControlStateNormal];
        [self.coverView addSubview:self.lastBtn];
        
        self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lastBtn.frame) + 24, self.playBtn.y, 24, 24)];
        [self.nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.nextBtn.tag = 1003;
        [self.nextBtn setImage:[UIImage imageNamed:@"nextVideo"] forState:UIControlStateNormal];
        [self.coverView addSubview:self.nextBtn];
        
        self.nowTime = [[UILabel alloc]init];
        self.nowTime.text = @"00:00:03";
        self.nowTime.font = [UIFont systemFontOfSize:11];
        self.nowTime.textColor = [UIColor redColor];
        [self.nowTime sizeToFit];
        CGSize nowTimeSize = self.nowTime.size;
        self.nowTime.frame = CGRectMake(CGRectGetMaxX(self.nextBtn.frame) + 80, self.nextBtn.y, nowTimeSize.width, 24);
        [self.coverView addSubview:self.nowTime];
        
        self.allTime = [[UILabel alloc]init];
        self.allTime.text = @"00:00:55";
        self.allTime.font = [UIFont systemFontOfSize:11];
        self.allTime.textColor = [UIColor redColor];
        [self.allTime sizeToFit];
        CGSize allTimeSize = self.allTime.size;
        self.allTime.frame = CGRectMake(CGRectGetMaxX(self.nowTime.frame) + 24, self.nextBtn.y, allTimeSize.width, 24);
        [self.coverView addSubview:self.allTime];
        
        self.fullScreenBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.allTime.frame) + 24, self.playBtn.y, 24, 24)];
        [self.fullScreenBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.fullScreenBtn.tag = 1004;
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
        [self.coverView addSubview:self.fullScreenBtn];
        
        //计时器，循环执行
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(timeStack)
                                                      userInfo:nil
                                                       repeats:YES];

   }
// 移动滑块
- (void)moveTheSlider:(UISlider *)slider{
    self.playBtn.selected = YES;
    
    [self btnClickWithPlayAndPause];
    CGFloat  time = slider.value * self.allTimeNum;
    self.nowTime.text = [NSString timeFormatted:time];
     [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 1001:
            [self btnClickWithPlayAndPause];
            break;
        case 1002:
            [self btnClickChangeVideo:NO];
            break;
        case 1003:
            [self btnClickChangeVideo:YES];
            break;
        case 1004:
            [self goFullScreen];
            break;
        case 1005:
            
            break;
            
            
        default:
            break;
    }
}
// 点击暂停 和 播放
- (void)btnClickWithPlayAndPause{
    if (self.playBtn.selected) {
        self.playBtn.selected = NO;
        [self.player pause];
    }else{
        self.playBtn.selected = YES;
           [self.player play];
    }
}

// 进入全屏
- (void)goFullScreen{
  
    if (!_isFullScreen) {
        _isFullScreen = YES;
        _originalFrame =  self.frame;
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        CGFloat height = viewSize.width;
        CGFloat width = viewSize.height;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
        [UIView animateWithDuration:0.5 animations:^{
            
            self.backImageView.frame = CGRectMake(0, 0, width, height);
            self.coverView.frame = CGRectMake(0, 0, width, height);
            self.frame = frame;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
            [currentWindow addSubview:self];
          
        } completion:^(BOOL finished) {
            [self layoutSubviews];
        }];

        
    }else{
          _isFullScreen = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
            
            self.frame = _originalFrame;
            self.backImageView.frame = CGRectMake(0, 0, _originalFrame.size.width, _originalFrame.size.height);
            self.coverView.frame = CGRectMake(0, 0, _originalFrame.size.width, _originalFrame.size.height);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.superView addSubview:self];
          
            [self layoutSubviews];
        }];
    }
}
// 盖板是否隐藏
- (void)coverViewShowOrHide{
    self.coverView.hidden = self.coverView.hidden == NO?YES:NO;
}

// 背景是否隐藏
- (void)backViewShowOrHide{
    self.coverView.hidden = self.coverView.hidden == NO?YES:NO;
}
// 改变视频播放
- (void)btnClickChangeVideo:(BOOL)isNextVide{
    [self btnClickWithPlayAndPause];
    if (isNextVide) {
        if (self.nextVideoBlock) {
            self.nextVideoBlock([self.videoInfo objectForKey:@"fileName"]);
        }
    }else{
        if (self.lastVideoBlock) {
            self.lastVideoBlock([self.videoInfo objectForKey:@"fileName"]);
        }
    }
}


- (void)setVideoInfo:(NSMutableDictionary *)videoInfo{
    _videoInfo = videoInfo;
    NSInteger fimeTime = [[videoInfo objectForKey:@"FileTime"] integerValue];
    self.allTimeNum = fimeTime;
    NSString * time  = [NSString timeFormatted:fimeTime];
    self.allTime.text = time;
    
    NSString * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //        NSString * path = @"http://dvideo.spriteapp.cn/video/2016/1117/582db0698584d_wpd.mp4";
    NSString * path =  [NSString stringWithFormat:@"%@/%@",documentPaths,[videoInfo objectForKey:@"fileName"]];
    
    NSLog(@"%@",path);
    //        NSURL *url = [NSURL URLWithString:path];
    NSURL * url = [NSURL fileURLWithPath:path];
    //            AVAsset *asset = [AVAsset assetWithURL:url];
    //    NSLog(@"%lld-time---",asset.duration.value /asset.duration.timescale );
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    //    self.backImageView.frame = CGRectMake(0, 100, 375, 400);
    [self btnClickWithPlayAndPause];

}


#pragma mark - 计时器事件
- (void)timeStack{
    if (_playerItem.duration.timescale != 0){
        //当前进度
        self.slider.value        = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);
        self.nowTime.text = [NSString timeFormatted:CMTimeGetSeconds([_playerItem currentTime])];
    }
}

@end
