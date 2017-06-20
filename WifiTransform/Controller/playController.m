//
//  playController.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/13.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "playController.h"
#import "customLayerView.h"


@interface playController ()


@end

@implementation playController

- (void)setVideoName:(NSString *)videoName{
    _videoName = videoName;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.title = [self.videoInfo objectForKey:@"fileName"];
    self.view.backgroundColor = [UIColor whiteColor];
    customLayerView * view = [[customLayerView alloc]initWithFrame:CGRectMake(0, 100, 375, 200) andSuperView:self.view];
    view.videoName = self.videoName;
    view.videoInfo = self.videoInfo;
    [self.view addSubview:view];
    
     __block __typeof(view) weakView = view;
        view.lastVideoBlock = ^(NSString *fileName) {
            NSLog(@"上一个");
            [self.fileList enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:fileName]) {
                    if (idx == 0) return ;
                    weakView.videoInfo = self.videoInfoArr[idx - 1];
                  self.navigationController.navigationItem.title = fileName;
                }
            }];
            
        };
    
        view.nextVideoBlock = ^(NSString *fileName) {
            NSLog(@"下一个");
                [self.fileList enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:fileName]) {
                        if (idx == self.fileList.count - 1) return ;
                        weakView.videoInfo = self.videoInfoArr[idx + 1];
                        self.navigationController.navigationItem.title = fileName;
                    }
                }];
        };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden{
    return  YES;
}
@end
