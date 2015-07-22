//
//  HooPhotoStreamCategoryList.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

@class HooPhotoStreamCategory;

@interface HooPhotoStreamCategoryList : NSObject
/*
 */
+ (instancetype)DefaultList;

- (NSUInteger)categoryCount;

- (NSUInteger)indexOfSelectedCategory;

- (void)selectCategoryAtIndex:(NSUInteger)index;

- (HooPhotoStreamCategory *)categoryAtIndex:(NSUInteger)index;

- (void)removeAllCategories;

@end
