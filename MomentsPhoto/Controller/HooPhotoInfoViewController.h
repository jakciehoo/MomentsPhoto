//
//  HooPhotoInfoViewController.h
//  MomentsPhoto
//
//  Created by HooJackie on 14/7/20.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HooPhotoInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, copy)NSString *pTitle;
@property (nonatomic, copy)NSString *uName;

@end
