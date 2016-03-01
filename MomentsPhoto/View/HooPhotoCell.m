//
//  HooPhotoCell.m
//  MomentsPhoto
//
//  Created by HooJackie on 14/7/17.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "HooPhoto.h"
@implementation HooPhotoCell

- (void)setPhoto:(HooPhoto *)photo
{
    _photo = photo;
    __weak typeof(self) weakSelf = self;
    
    [self.imageView sd_setImageWithURL:_photo.thumbnailURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(self) strongSelf = weakSelf;

        if (image) {
            [strongSelf.activityIndicator stopAnimating];
            
            if (cacheType == SDImageCacheTypeNone) {
                strongSelf.imageView.alpha = 0.0f;
                [UIView animateWithDuration:0.7f animations:^{
                    strongSelf.imageView.alpha = 1.0f;
                }];
            }
            
        }else if (error){
            NSLog(@"SDWebImage Error - %@",[error localizedDescription]);
        }
    }];
}

@end
