//
//  HooPhotoStreamPage.h
//  MomentsPhoto
// 此模型代表照片流中的一页，每页包含一定数量的照片集合。
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

@class HooPhoto;
@class HooPhotoStream;

@interface HooPhotoStreamPage : NSObject
/*
 引用此页所在的照片流
 */
@property (nonatomic, weak, readonly) HooPhotoStream *photoStream;

/*
 获取当前也所在页数，起始值为1
 */
@property (nonatomic,assign, readonly) NSInteger pageNumber;
/*
 初始化页面的照片流数据
 */
- (instancetype)initWithPhotoStream:(HooPhotoStream *)photoStream
                         pageNumber:(NSInteger)pageNmuber;
/*
  根据字典设置页面属性
 */
- (void)setAttribute:(NSDictionary *)attributes;
/*
    获取页面中的照片数量
 */
- (NSUInteger)photoCount;
/*
    根据索引获取页面中的照片
 */
- (HooPhoto *)photoAtIndex:(NSUInteger)index;

@end
