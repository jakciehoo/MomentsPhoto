//
//  HooPhotoStreamPage.h
//  MomentsPhoto
// 照片流。用于显示到多个页面中，提高检索效率
//  Created by HooJackie on 14/7/16.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <PXAPI.h>
@class HooPhoto;

typedef void(^HooPhotoCompletionBlock)(HooPhoto *photo,NSError *error);

//没有获取到照片时照片数量HooPhotoStreamNoCount
enum {
    HooPhotoStreamNoPhotoCount = -1
};

@interface HooPhotoStream : NSObject

// 获取照片类型
@property (nonatomic, assign, readonly) PXAPIHelperPhotoFeature feature;
//获取照片目录
@property (nonatomic, assign, readonly) PXPhotoModelCategory category;

//初始化照片流
- (instancetype)initWithFeature:(PXAPIHelperPhotoFeature)feature
                       category:(PXPhotoModelCategory)category;

//获取照片流中的照片，如果没有完成加载照片流，值为HooPhotoStreamNoCount
- (NSInteger)photoCount;

//从网络获取照片
- (HooPhoto *)photoAtIndex:(NSUInteger)index completion:(HooPhotoCompletionBlock)completionBlock;

@end
