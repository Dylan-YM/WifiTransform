//
//  CustomBtn.m
//  WifiTransform
//
//  Created by yumiao on 2017/3/22.
//  Copyright © 2017年 richard. All rights reserved.
//

#import "CustomBtn.h"

@interface CustomBtn ()

@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) CGRect imageRect;

@end

@implementation CustomBtn

+ (id)buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName imageRect:(CGRect)imageRect title:(NSString *)title titleRect:(CGRect)titleRect
{
    CustomBtn *textImageButton = [[CustomBtn alloc]init];;
    if (textImageButton)
    {
        textImageButton.titleRect = titleRect;
        textImageButton.imageRect = imageRect;
        
        textImageButton.frame = frame;
        UIImage *image = [UIImage imageNamed:imageName];
        [textImageButton setImage:image forState:UIControlStateNormal];
        [textImageButton setTitle:title forState:UIControlStateNormal];
    }
    
    return textImageButton;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return self.titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return self.imageRect;
}
@end
