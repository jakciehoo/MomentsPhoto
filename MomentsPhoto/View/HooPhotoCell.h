//
//  HooPhotoCell.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

@class HooPhoto;

@interface HooPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) HooPhoto *photo;


@end
