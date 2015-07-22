//
//  HooPhoto.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2015年 jackie. All rights reserved.
//



@class HooPhotoStreamPage;

@interface HooPhoto : NSObject

@property (nonatomic, copy, readonly)NSURL *thumbnailURL;
@property (nonatomic, copy, readonly)NSURL *photoURL;
@property (nonatomic, copy, readonly)NSString *title;
@property (nonatomic, copy, readonly)NSString *userFullName;
@property (nonatomic, copy, readonly)HooPhotoStreamPage *photoStreamPage;

- (instancetype)initWithPage:(HooPhotoStreamPage *)page attributes:(NSDictionary *)attributes;

@end
