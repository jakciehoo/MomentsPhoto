//
//  HooMainCollectionViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooMainCollectionViewController.h"
#import "FlatUIKit.h"
#import "HooPhotoViewController.h"
#import "HooPhotoStream.h"
#import "SVPullToRefresh.h"
#import "HooPhotoCell.h"
#import "HooPhotoStreamCategory.h"
#import "HooPhotoStreamCategoryList.h"
#import "HooFeatureListViewController.h"
#import "HooCategoryListViewController.h"
#import "RESideMenu.h"


static NSString * const reuseIdentifier = @"photoCell";
static NSString * const kSegueIdentifierCategoryPopover = @"showCategoryList";
@interface HooMainCollectionViewController ()<HooFeatureListViewControllerDelegate,HooCategoryListViewControllerDelegate>

@property (nonatomic, weak) UIPopoverController *categoryListPopoverController;
@property (nonatomic, strong, readonly)HooPhotoViewController *photoViewController;
@property (nonatomic, strong)HooPhotoStream *photoStream;
@property (nonatomic, strong, readonly) NSArray *photoStreamFeatures;
@property (nonatomic,strong) HooPhotoStreamCategory *selectedCategory;

@end

@implementation HooMainCollectionViewController

@synthesize photoViewController = _photoViewController;
@synthesize photoStreamFeatures = _photoStreamFeatures;

#pragma  mark -懒加载
//懒加载
- (HooPhotoViewController *)photoViewController
{
    if (!_photoViewController) {
        _photoViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([HooPhotoViewController class])];
    }
    return _photoViewController;
}

- (NSArray *)photoStreamFeatures
{
    if (!_photoStreamFeatures) {
        _photoStreamFeatures = @[@(PXAPIHelperPhotoFeaturePopular),
                                 @(PXAPIHelperPhotoFeatureEditors),
                                 @(PXAPIHelperPhotoFeatureUpcoming),
                                 @(PXAPIHelperPhotoFeatureFreshToday)];
    }
    return _photoStreamFeatures;
}

- (HooPhotoStreamCategory *)selectedCategory
{
    if (!_selectedCategory) {
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"];
        HooPhotoStreamCategory *category = [[HooPhotoStreamCategoryList DefaultList] categoryAtIndex:index];
        _selectedCategory = category;
        self.navigationItem.rightBarButtonItem.title = _selectedCategory.title;
    }
    return _selectedCategory;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //解决iOS7 默认的View的起点在屏幕左上角带来的问题，这里的操作让它显示导航栏下
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
         self.edgesForExtendedLayout = UIRectEdgeNone;//不延伸
         self.extendedLayoutIncludesOpaqueBars = NO;
         self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self configureNavigationBar];
    [self configureBarButtonItem];

    [self addSVPullToRefreshForViewController];
    [self setupView];
}

- (void)setupView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     CGFloat itemWidth = (self.view.bounds.size.width - 4)/3;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.footerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, 100.0);
    self.collectionView.collectionViewLayout = flowLayout;
}


#pragma mark - 定制视图样式

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor blackColor]];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;


}


- (void)configureBarButtonItem
{
    NSArray *itemArrray = @[self.navigationItem.leftBarButtonItem,self.navigationItem.rightBarButtonItem];
    
    for (UIBarButtonItem *item in itemArrray) {
        [item configureFlatButtonWithColor:[UIColor alizarinColor]
                          highlightedColor:[UIColor pomegranateColor]
                              cornerRadius:3.0f];
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor: [UIColor clearColor]];
        [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        
        NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSShadowAttributeName:shadow};
        
        [item setTitleTextAttributes:textAttributes
                            forState:UIControlStateNormal];
    }
    

}

- (void)configurePopover
{
    [self.categoryListPopoverController configureFlatPopoverWithBackgroundColor:[UIColor silverColor] cornerRadius:3.0f];
}

#pragma mark - 添加拖拽视图刷新功能，使用了优秀的第三方空间

- (void)addSVPullToRefreshForViewController
{
    __weak typeof(self) weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf reloadPhotoStreamFeature:weakSelf.photoStream.feature category:weakSelf.photoStream.category];
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
    }];
    self.collectionView.pullToRefreshView.textColor = [UIColor whiteColor];
    self.collectionView.pullToRefreshView.arrowColor = [UIColor whiteColor];
}

- (HooPhotoStream *)photoStream
{
    if (!_photoStream) {
        _photoStream = [[HooPhotoStream alloc] initWithFeature:kPXAPIHelperDefaultFeature category:self.selectedCategory.value];
    }
    return _photoStream;
}

- (void)reloadPhotoStreamFeature:(PXAPIHelperPhotoFeature)feature
                        category:(PXPhotoModelCategory)category
{
    self.photoStream = [[HooPhotoStream alloc] initWithFeature:feature category:category];
    [self.collectionView reloadData];

}

#pragma mark - View Rotation Events

/*
 We need to manually forward the view rotation events to TCPhotoModalViewController
 because it is not attached/related to any view controllers (it's view is added to
 UIWindow).
 Remember to check if TCPhotoModalViewController's view has been added to a window
 before forwarding the rotation events.
 */

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.photoViewController.view.window) {
        [self.photoViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.photoViewController.view.window) {
        [self.photoViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.photoViewController.view.window) {
        [self.photoViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}



#pragma mark <UICollectionViewDataSource>




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger photoCount = self.photoStream.photoCount;
    return HooPhotoStreamNoPhotoCount == photoCount ? kPXAPIHelperDefaultResultsPerPage : photoCount;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HooPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.imageView.image = nil;
    [cell.activityIndicator startAnimating];
    
    HooPhoto *photo = [self.photoStream photoAtIndex:indexPath.item completion:^(HooPhoto *photo, NSError *error) {
        if (photo) {
            [collectionView reloadData];
        }else if (error){
            NSLog(@"500px Error - %@",[error localizedDescription]);
        }
    }];
    cell.photo = photo;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HooPhotoCell *photoCell = (HooPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (photoCell.photo) {
        [self.photoViewController presentWithWindow:self.view.window photo:photoCell.photo sender:photoCell];
    }
}

#pragma mark - HooCategoryListViewController  代理
- (void)categoryListViewController:(HooCategoryListViewController *)categoryListViewController didSelectedCategory:(HooPhotoStreamCategory *)category
{
    [self.categoryListPopoverController dismissPopoverAnimated:YES];
    [self reloadPhotoStreamFeature:self.photoStream.feature category:category.value];
    self.navigationItem.rightBarButtonItem.title = category.title;
}
#pragma mark - HooFeatureListViewController 代理
- (void)featureListViewController:(HooFeatureListViewController *)featureListViewController didSelectedfeature:(NSInteger)featureIndex featureName:(NSString *)featureName
{
    PXAPIHelperPhotoFeature selectedFeature = [self.photoStreamFeatures[featureIndex] integerValue];
    
    [self reloadPhotoStreamFeature:selectedFeature category:self.photoStream.category];
    self.navigationItem.leftBarButtonItem.title = featureName;

}


#pragma mark - IBAction
- (IBAction)presentLeftMenuViewController:(id)sender
{
    [super presentLeftMenuViewController:sender];
    HooFeatureListViewController *featureCtrl = (HooFeatureListViewController *)self.sideMenuViewController.leftMenuViewController;
    featureCtrl.delegate = self;
}

- (IBAction)  presentRightMenuViewController:(id)sender
{
    [super presentRightMenuViewController:sender];
    
    HooCategoryListViewController *categoryCtrl = (HooCategoryListViewController *)self.sideMenuViewController.rightMenuViewController;
    categoryCtrl.delegate = self;
}

@end
