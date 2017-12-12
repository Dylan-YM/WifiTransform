//
//  ViewController.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/10.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "ViewController.h"
#import "MyHTTPConnection.h"
#import "playController.h"
#import "VideoTableViewCell.h"
#import "ViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import "KxMovieViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) NSArray * fileList;
@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * dataInfo;
@property (nonatomic, strong) ViewModel * viewModel;
@end

@implementation ViewController{
    
    HTTPServer * httpServer;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)setNum:(NSInteger)num{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有视频";
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel = [ViewModel ShareInstance];
    
    NSLog(@"%@:%zd-----------",[self.viewModel getIPAddress],[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue]);
    UIAlertController * alert = [[UIAlertController alloc]init];
    alert.title = [NSString stringWithFormat:@"IP:%@:%zd域名",[self.viewModel getIPAddress],[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue]];
    UIAlertAction * retain = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:retain];
    [self presentViewController:alert animated:YES completion:nil];

    self.fileList = [self.viewModel getVideoList];
    self.dict = [self getFileDetail];
    [self setupUI];
}
- (void)setupUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 375, 667 - 44) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableHeaderView = nil;
    [self.view addSubview:self.mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableViewDateSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fileList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTable"];
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VideoTable"];
    }
    //    NSString * fileName = self.fileList[indexPath.row];
    cell.videoInfo = self.dataInfo[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
   path = self.fileList[indexPath.row];
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    // disable buffering
    //parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
    //parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];}


- (BOOL)prefersStatusBarHidden{
    
    return  YES;
}

- (NSMutableDictionary *)getFileDetail{
    NSMutableDictionary * videoInfo = [[NSMutableDictionary alloc]init];
    //    NSString * fileName = self.fileList[1];
    for (NSString * fileName in self.fileList) {
        NSInteger  fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil] fileSize];
        NSLog(@"-----------%zd",fileSize );
        NSURL * url = [NSURL fileURLWithPath:fileName];
//        AVAsset * asset = [AVAsset assetWithURL:url];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        [videoInfo setValue:fileName.lastPathComponent forKey:@"fileName"];
        [videoInfo setValue:@(asset.duration.value/asset.duration.timescale) forKey:@"FileTime"];
        [videoInfo setValue:@(fileSize) forKey:@"fileSize"];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        [videoInfo setValue:thumb forKey:@"icon"];
        
    }
    return  videoInfo;
    
}
- (NSMutableArray *)dataInfo{
    if (!_dataInfo) {
        _dataInfo = [[NSMutableArray alloc]init];
        for (NSString * fileName in self.fileList) {
            NSMutableDictionary * videoInfo = [[NSMutableDictionary alloc]init];
            NSInteger  fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil] fileSize];
            NSLog(@"-----------%zd",fileSize );
            NSURL * url = [NSURL fileURLWithPath:fileName];
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
              [videoInfo setValue:fileName.lastPathComponent forKey:@"fileName"];
            [videoInfo setValue:@(asset.duration.value/asset.duration.timescale) forKey:@"FileTime"];
            [videoInfo setValue:@(fileSize) forKey:@"fileSize"];
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            [videoInfo setValue:thumb forKey:@"icon"];
            [_dataInfo addObject:videoInfo];
          
            
        }
    }
    return _dataInfo;
}
-  (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc]init];
    }
    return _dict;
}

@end
