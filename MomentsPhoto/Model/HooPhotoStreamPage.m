//
//  HooPhotoStreamPage.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooPhotoStreamPage.h"
#import "HooPhotoStream.h"
#import "HooPhoto.h"

@interface HooPhotoStreamPage ()

@property (nonatomic, strong)NSMutableArray *photos;

@end

@implementation HooPhotoStreamPage

- (instancetype)initWithPhotoStream:(HooPhotoStream *)photoStream pageNumber:(NSInteger)pageNmuber
{
    if (self = [super init]) {
        _photoStream = photoStream;
        _pageNumber = pageNmuber;
    }
    return self;
}

- (void)setAttribute:(NSDictionary *)attributes
{
    NSArray *photoArray = attributes[@"photos"];
    self.photos = [[NSMutableArray alloc] initWithCapacity:[photoArray count]];
    
    for (NSDictionary *dict in photoArray) {
        HooPhoto *photo = [[HooPhoto alloc] initWithPage:self attributes:dict];
        [self.photos addObject:photo];
    }
}

- (NSUInteger)photoCount
{
    return self.photos.count;
}

- (HooPhoto *)photoAtIndex:(NSUInteger)index
{
    return (index < self.photoCount) ? self.photos[index] : nil;
}

@end
