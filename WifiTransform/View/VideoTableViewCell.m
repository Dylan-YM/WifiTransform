//
//  VideoTableViewCell.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/16.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "CustomBtn.h"
#import "NSString+timeFormatted.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface VideoTableViewCell ()

@end
@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setupUI{
    
    self.iconBtn = [CustomBtn buttonWithFrame:CGRectMake(10, 10, 70, 80) imageName:@"user_wx" imageRect:CGRectMake(5, 5, 60, 40) title:@"mp4" titleRect:CGRectMake(0, 80 - 12, 70, 12)];
    self.iconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.iconBtn.frame = CGRectMake(10, 10, 70, 80);
    self.iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.iconBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.iconBtn];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconBtn.frame) + 10, CGRectGetMinY(self.iconBtn.frame), SCREEN_WIDTH - CGRectGetMaxX(self.iconBtn.frame) -20, 50);
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.text = @"费洛夫28勇士按实际好打灰色空间电话卡几乎是可敬的 阿萨德扩军豪阿萨德扩军豪阿";
     [self.contentView addSubview:self.nameLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.frame = CGRectMake(CGRectGetMaxX(self.iconBtn.frame) + 10, CGRectGetMaxY(self.iconBtn.frame) - 10, 50, 10);
    self.sizeLabel.textColor = [UIColor blackColor];
    self.sizeLabel.text = @"1.44GB";
    self.sizeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.sizeLabel];
   
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"23:00/02:00:38";
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    [self.timeLabel sizeToFit];
    CGSize timeSize = self.timeLabel.frame.size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) - timeSize.width, CGRectGetMaxY(self.iconBtn.frame) - 10, timeSize.width, 10);
     [self.contentView addSubview:self.timeLabel];
}

- (void)setVideoInfo:(NSMutableDictionary *)videoInfo{
    _videoInfo = videoInfo;
    //    self.sizeLabel.text = [NSString stringWithFormat:@"%zd", [[videoInfo objectForKey:@"fileSize"] integerValue]];
    self.sizeLabel.text = [NSString FileSizeFormatted:[[videoInfo objectForKey:@"fileSize"] integerValue]];
    NSString * name = [videoInfo objectForKey:@"fileName"];
    NSInteger lenth  = [[self getRangeStr:name findText:@"."][[[self getRangeStr:name findText:@"."] count] -1] integerValue];
    self.nameLabel.text = [name substringToIndex:lenth] ;
    NSString * string = [name substringFromIndex:lenth +1];
    [self.iconBtn setTitle:string forState:UIControlStateNormal];
    NSInteger fimeTime = [[videoInfo objectForKey:@"FileTime"] integerValue];
    NSString * time  = [NSString timeFormatted:fimeTime];
    UIImage * image = [videoInfo objectForKey:@"icon"];
    if (image) {
        [self.iconBtn setImage:image forState:UIControlStateNormal];
    }
    self.timeLabel.text = time;
    
}
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {
                
                //去掉这个abc字符串
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}



@end
