//
//  ViewModel.m
//  WifiTransform
//
//  Created by yumiao on 2017/12/8.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "ViewModel.h"
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation ViewModel

+ (instancetype)ShareInstance{

    static ViewModel *singleton = nil;
    if (! singleton) {
        singleton = [[self alloc] init];
    }
    return singleton;

}
- (NSArray *)getVideoList{
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
        
      isDir =  [[NSFileManager  defaultManager] fileExistsAtPath:path isDirectory:(&isDir)];
        
        NSString *ext = file.pathExtension.lowercaseString;
        if (isDir) {
            if ([ext isEqualToString:@"mp3"] ||
                [ext isEqualToString:@"caff"]||
                [ext isEqualToString:@"aiff"]||
                [ext isEqualToString:@"ogg"] ||
                [ext isEqualToString:@"wma"] ||
                [ext isEqualToString:@"m4a"] ||
                [ext isEqualToString:@"m4v"] ||
                [ext isEqualToString:@"rmvb"] ||
                [ext isEqualToString:@"wmv"] ||
                [ext isEqualToString:@"3gp"] ||
                [ext isEqualToString:@"mp4"] ||
                [ext isEqualToString:@"mov"] ||
                [ext isEqualToString:@"avi"] ||
                [ext isEqualToString:@"mkv"] ||
                [ext isEqualToString:@"mpeg"]||
                [ext isEqualToString:@"mpg"] ||
                [ext isEqualToString:@"flv"] ||
                [ext isEqualToString:@"vob"]) {
                
                [dirArray addObject:[NSString stringWithFormat:@"%@",path]];
            }
        }
        isDir=NO;
    }
    return dirArray;
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
@end
