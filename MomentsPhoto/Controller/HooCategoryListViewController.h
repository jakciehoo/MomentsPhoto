//
//  HooCategoryListViewController.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//
@class HooCategoryListViewController;
@class HooPhotoStreamCategory;


@protocol HooCategoryListViewControllerDelegate <NSObject>
@required
- (void)categoryListViewController:(HooCategoryListViewController *)categoryListViewController didSelectedCategory:(HooPhotoStreamCategory *)category;

@end

@interface HooCategoryListViewController : UITableViewController

@property (nonatomic,weak) id<HooCategoryListViewControllerDelegate> delegate;

@end
