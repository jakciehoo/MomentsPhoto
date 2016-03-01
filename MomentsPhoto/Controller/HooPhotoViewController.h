//
//  HooPhotoViewController.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

@class HooPhoto;

@interface HooPhotoViewController : UIViewController

- (void)presentWithWindow:(UIWindow *)window photo:(HooPhoto *)photo sender:(UIView *)sender;
- (void)dismiss;

@end
