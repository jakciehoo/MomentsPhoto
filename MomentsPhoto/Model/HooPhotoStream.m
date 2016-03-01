//
//  HooPhotoStreamPage.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooPhotoStream.h"
#import "HooPhotoStreamPage.h"
#import "DescriptionBuilder.h"

typedef void(^HooPhotoStreamCompletionBlock)(HooPhotoStreamPage *page, NSError *error);

@interface HooPhotoStream ()

//照片流中的照片数量
@property (nonatomic,assign) NSInteger photoCount;
//
@property (nonatomic,strong) NSPointerArray *pages;

@end

@implementation HooPhotoStream

- (instancetype)initWithFeature:(PXAPIHelperPhotoFeature)feature category:(PXPhotoModelCategory)category
{
    self = [super init];
    if (self) {
        _feature = feature;
        _category = category;
        _photoCount = HooPhotoStreamNoPhotoCount;
        
    }
    return self;
}

- (NSInteger)photoCount
{
    return _photoCount;
}

#pragma - Pages

- (NSPointerArray *)pages
{
    if (!_pages) {
        _pages = [NSPointerArray strongObjectsPointerArray];
        
    }
    return _pages;
}

- (HooPhoto *)photoAtIndex:(NSUInteger)index completion:(HooPhotoCompletionBlock)completionBlock
{
    NSUInteger pageIndex = index / kPXAPIHelperDefaultResultsPerPage;
    NSUInteger photoIndexWithinPage = index % kPXAPIHelperDefaultResultsPerPage;
    
    HooPhotoStreamPage *page = [self pageAtIndex:pageIndex];
    
    if (page) {
        HooPhoto *photo = [page photoAtIndex:photoIndexWithinPage];
        return photo;
    }
    
    page = [[HooPhotoStreamPage alloc] initWithPhotoStream:self pageNumber:pageIndex + 1];
    [self setPage:page atIndex:pageIndex];
    [self fetchPage:page completion:^(HooPhotoStreamPage *page, NSError *error) {
        HooPhoto *photo = [page photoAtIndex:photoIndexWithinPage];
        completionBlock(photo,error);
    }];
    
    return nil;
    
}

- (HooPhotoStreamPage *)pageAtIndex:(NSUInteger)pageIndex
{
    return (pageIndex < [self.pages count]) ? (__bridge HooPhotoStreamPage *)[self.pages pointerAtIndex:pageIndex] :nil;
}

- (void)setPage:(HooPhotoStreamPage *)page atIndex:(NSUInteger)pageIndex
{
    if (pageIndex >= self.pages.count) {
        self.pages.count = pageIndex+1;
    }
    [self.pages replacePointerAtIndex:pageIndex withPointer:(__bridge void *)(page)];
}
- (void)fetchPage:(HooPhotoStreamPage *)page completion:(HooPhotoStreamCompletionBlock)completionBlock
{
    HooPhotoStreamPage * __block blockPage = page;
    
    [PXRequest requestForPhotoFeature:self.feature resultsPerPage:kPXAPIHelperDefaultResultsPerPage page:page.pageNumber photoSizes:(PXPhotoModelSizeThumbnail|PXPhotoModelSizeLarge) sortOrder:kPXAPIHelperDefaultSortOrder except:PXPhotoModelCategoryNude only:self.category
                           completion:^(NSDictionary *results, NSError *error){
                           
                               if (results) {
                                   [blockPage setAttribute:results];
                                   
                                   self.photoCount = [results[@"total_items"] integerValue];
                                   self.pages.count = [results[@"total_pages"] unsignedIntegerValue];
                                   
                               }else if (error){
                                   blockPage = nil;
                                   [self setPage:blockPage atIndex:page.pageNumber -1];
                               }
                               completionBlock(blockPage,error);
                           }];
}

#pragma mark - Debug

- (NSString *)description
{
    return [DescriptionBuilder reflectDescription:self style:DescriptionStyleMultiLine];
}




@end
