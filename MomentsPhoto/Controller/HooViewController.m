//
//  HooViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 14/7/24.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooViewController.h"

@interface HooViewController ()


@end

@implementation HooViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.delegate = self;
}


@end
