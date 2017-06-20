//
//  ViewController.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/10.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "ViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "YMIPHepler.h"
#import "playController.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "VideoTableViewCell.h"

#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) NSArray * fileList;
@property (nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSMutableArray * dataInfo;
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
    NSLog(@"%@:%zd-----------",[self getIPAddress],[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue]);
    UIAlertController * alert = [[UIAlertController alloc]init];
    alert.title = [NSString stringWithFormat:@"IP:%@:%zd域名",[self getIPAddress],[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue]];
    UIAlertAction * retain = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:retain];
    [self presentViewController:alert animated:YES completion:nil];

    NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@---documentpath",documentPaths.lastObject);
    NSString *documentDir= [documentPaths objectAtIndex:0];
    
    NSError *error=nil;
    
    NSArray *fileList= [[NSArray alloc] init];
    
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList= [  [NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDir error:&error];
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray= [[NSMutableArray alloc] init];
    BOOL isDir=NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        
        NSString *path= [documentDir stringByAppendingPathComponent:file];
        
        [[NSFileManager  defaultManager] fileExistsAtPath:path isDirectory:(&isDir)];
        
        if (isDir) {
            
            [dirArray addObject:file];
            
        }
        isDir=NO;
    }
    self.fileList = fileList;
    self.dict = [self getFileDetail];
    
    [self setupUI];
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
    
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
    NSString * fileName = self.fileList[indexPath.row];
    playController * vc = [[playController alloc]init];
    vc.videoInfoArr = self.dataInfo;
    vc.videoName = fileName;
    vc.fileList = self.fileList;
    vc.videoInfo = self.dataInfo[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
- (BOOL)prefersStatusBarHidden{
    
    return  YES;
}

- (NSMutableDictionary *)getFileDetail{
    NSMutableDictionary * videoInfo = [[NSMutableDictionary alloc]init];
    NSString *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //    NSString * fileName = self.fileList[1];
    for (NSString * fileName in self.fileList) {
        NSString * path =  [NSString stringWithFormat:@"%@/%@",documentPaths,fileName];
        NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
        NSLog(@"-----------%zd",fileSize );
        
        NSURL * url = [NSURL fileURLWithPath:path];
        
        AVAsset * asset = [AVAsset assetWithURL:url];
        
        [videoInfo setValue:fileName forKey:@"fileName"];
        [videoInfo setValue:@(asset.duration.value/asset.duration.timescale) forKey:@"FileTime"];
        [videoInfo setValue:@(fileSize) forKey:@"fileSize"];
        
    }
    return  videoInfo;
    
}
- (NSMutableArray *)dataInfo{
    if (!_dataInfo) {
        _dataInfo = [[NSMutableArray alloc]init];
        
        NSString *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        for (NSString * fileName in self.fileList) {
            NSMutableDictionary * videoInfo = [[NSMutableDictionary alloc]init];
            NSString * path =  [NSString stringWithFormat:@"%@/%@",documentPaths,fileName];
            NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
            NSLog(@"-----------%zd",fileSize );
            
            NSURL * url = [NSURL fileURLWithPath:path];
            
            AVAsset * asset = [AVAsset assetWithURL:url];
            
            [videoInfo setValue:fileName forKey:@"fileName"];
            [videoInfo setValue:@(asset.duration.value/asset.duration.timescale) forKey:@"FileTime"];
            [videoInfo setValue:@(fileSize) forKey:@"fileSize"];
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
