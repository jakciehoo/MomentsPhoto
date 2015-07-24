//
//  HooPhotoInfoViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/20.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooPhotoInfoViewController.h"

@interface HooPhotoInfoViewController ()

@end

@implementation HooPhotoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.userName.text = self.uName.length != 0 ? self.uName : @"不详";
    [self.userName sizeToFit];
    self.photoTitle.text = self.pTitle.length != 0 ? self.pTitle : @"不详";
    [self.photoTitle sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
