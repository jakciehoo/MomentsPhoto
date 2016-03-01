//
//  HooPhoto.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooPhoto.h"
#import "HooPhotoStreamPage.h"

//照片尺寸枚举
typedef NS_ENUM(NSInteger, HooPhotoSize){
    HooPhotoSizeThumbnail = 3,
    HooPhotoSizeLarge = 4,
};




@implementation HooPhoto


- (instancetype)initWithPage:(HooPhotoStreamPage *)page attributes:(NSDictionary *)attributes
{
    
    self = [super init];
    if (self) {
        _photoStreamPage = page;
        [self setAttributes:attributes];
    }
    return self;
}

//获取照片属性信息
- (void)setAttributes:(NSDictionary *)attributes
{
    //照片标题
    _title = attributes[@"name"];
    //照片用户名称
    _userFullName = attributes[@"user"][@"fullName"];
    
    NSArray *imageArray = attributes[@"images"];
    
    for (NSDictionary *imageDict in imageArray) {
        NSInteger imageSize = [imageDict[@"size"] integerValue];
        NSURL *imageURL = [[NSURL alloc] initWithString:imageDict[@"url"]];
        
        switch (imageSize) {
            case HooPhotoSizeThumbnail:
                _thumbnailURL = imageURL;
                break;
            case HooPhotoSizeLarge:
                _photoURL = imageURL;
                break;
            default:
                break;
        }
    }
    
}

@end
