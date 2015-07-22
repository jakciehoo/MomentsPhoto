//
//  HooPhotoStreamCategory.h
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXAPI.h"

@interface HooPhotoStreamCategory : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) PXPhotoModelCategory value;

- (instancetype)initWithTitle:(NSString *)title value:(PXPhotoModelCategory)value selected:(BOOL)selected;

@end
