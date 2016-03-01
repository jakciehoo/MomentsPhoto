//
//  HooPhotoStreamCategoryList.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooPhotoStreamCategoryList.h"
#import "HooPhotoStreamCategory.h"

@interface HooPhotoStreamCategoryList ()

@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
#pragma mark -
@implementation HooPhotoStreamCategoryList

+ (instancetype)DefaultList
{
    static HooPhotoStreamCategoryList *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HooPhotoStreamCategoryList alloc] init];
    });
    return sharedInstance;
}

- (NSUInteger)categoryCount
{
    return self.categories.count;
}

- (NSUInteger)indexOfSelectedCategory
{
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"];
    [self.categories[index] setSelected:YES];
    _selectedIndex = index;
    return _selectedIndex;
}

- (void)selectCategoryAtIndex:(NSUInteger)index
{
    if (index == self.selectedIndex) {
        return;
    }
    [self.categories[self.selectedIndex] setSelected:NO];
    [self.categories[index] setSelected:YES];
    self.selectedIndex = index;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selectedIndex"];
}

- (HooPhotoStreamCategory *)categoryAtIndex:(NSUInteger)index
{
    return self.categories[index];
}

- (void)removeAllCategories
{
    self.categories = nil;
}

-(NSArray *)categories
{
    if (!_categories) {
        _categories = [[[self class] supportedPhotoStreamCategories] copy];
    }
    return _categories;
}

+ (NSArray *)supportedPhotoStreamCategories
{
    NSArray *values = @[@(PXAPIHelperUnspecifiedCategory),
                        @(PXPhotoModelCategoryAbstract),
                        @(PXPhotoModelCategoryAnimals),
                        @(PXPhotoModelCategoryBlackAndWhite),
                        @(PXPhotoModelCategoryCelbrities),
                        @(PXPhotoModelCategoryCityAndArchitecture),
                        @(PXPhotoModelCategoryCommercial),
                        @(PXPhotoModelCategoryConcert),
                        @(PXPhotoModelCategoryFamily),
                        @(PXPhotoModelCategoryFashion),
                        @(PXPhotoModelCategoryFilm),
                        @(PXPhotoModelCategoryFineArt),
                        @(PXPhotoModelCategoryFood),
                        @(PXPhotoModelCategoryJournalism),
                        @(PXPhotoModelCategoryLandscapes),
                        @(PXPhotoModelCategoryMacro),
                        @(PXPhotoModelCategoryNature),
                        //@(PXPhotoModelCategoryNude),
                        @(PXPhotoModelCategoryPeople),
                        @(PXPhotoModelCategoryPerformingArts),
                        @(PXPhotoModelCategorySport),
                        @(PXPhotoModelCategoryStillLife),
                        @(PXPhotoModelCategoryStreet),
                        @(PXPhotoModelCategoryTransportation),
                        @(PXPhotoModelCategoryTravel),
                        @(PXPhotoModelCategoryUnderwater),
                        @(PXPhotoModelCategoryUrbanExploration),
                        @(PXPhotoModelCategoryWedding),
                        @(PXPhotoModelCategoryUncategorized)];
    
    NSArray *titles = @[NSLocalizedString(@"All Categories", @"所有分类"),
                        NSLocalizedString(@"Abstract", @"抽象"),
                        NSLocalizedString(@"Animals",@"动物"),
                        NSLocalizedString(@"Black and White",@"黑白"),
                        NSLocalizedString(@"Celebrities",@"名人"),
                        NSLocalizedString(@"City and Architecture",@"建筑"),
                        NSLocalizedString(@"Commercial",@"商业"),
                        NSLocalizedString(@"Concert",@"音乐"),
                        NSLocalizedString(@"Family",@"家庭"),
                        NSLocalizedString(@"Fashion",@"时尚"),
                        NSLocalizedString(@"Film",@"电影"),
                        NSLocalizedString(@"Fine Art",@"经典"),
                        NSLocalizedString(@"Food",@"食物"),
                        NSLocalizedString(@"Journalism",@"新闻"),
                        NSLocalizedString(@"Landscapes",@"风景"),
                        NSLocalizedString(@"Macro",@"写生"),
                        NSLocalizedString(@"Nature",@"自然"),
                        //NSLocalizedString(@"Nude",@"人体艺术"),
                        NSLocalizedString(@"People",@"人物描写"),
                        NSLocalizedString(@"Performing Arts",@"表演艺术"),
                        NSLocalizedString(@"Sport",@"运动"),
                        NSLocalizedString(@"Still Life",@"随手拍"),
                        NSLocalizedString(@"Street",@"街道"),
                        NSLocalizedString(@"Transporation",@"交通"),
                        NSLocalizedString(@"Travel",@"交通"),
                        NSLocalizedString(@"Underwater",@"海底世界"),
                        NSLocalizedString(@"Urban Exploration",@"都市生活"),
                        NSLocalizedString(@"Wedding",@"婚礼"),
                        NSLocalizedString(@"Uncategorized",@"其他")];
    return [self categoriesFromValues:values andTitle:titles];
}

+ (NSArray *)categoriesFromValues:(NSArray *)values andTitle:(NSArray *)titles
{
    NSMutableArray *categories = [[NSMutableArray alloc] initWithCapacity:values.count];
    [values enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        HooPhotoStreamCategory *category = [[HooPhotoStreamCategory alloc]
                                            initWithTitle:titles[idx]
                                                    value:[obj integerValue]
                                                 selected:NO];
        [categories addObject:category];
    }];
    return categories;
}


@end
