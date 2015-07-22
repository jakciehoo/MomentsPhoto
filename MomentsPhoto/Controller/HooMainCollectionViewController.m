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


static NSString * const reuseIdentifier = @"photoCell";
static NSString * const kSegueIdentifierCategoryPopover = @"showCategoryList";
@interface HooMainCollectionViewController ()
@property (weak, nonatomic) IBOutlet FUISegmentedControl *featureSegmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *categoryBarButtonItem;

@property (nonatomic, weak) UIPopoverController *categoryListPopoverController;
@property (nonatomic, strong, readonly)HooPhotoViewController *photoViewController;
@property (nonatomic, strong)HooPhotoStream *photoStream;
@property (nonatomic, strong, readonly) NSArray *photoStreamFeatures;
@property (nonatomic,strong) HooPhotoStreamCategory *selectedCategory;

- (IBAction)featureChanged:(id)sender;


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
        self.categoryBarButtonItem.title = category.title;
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
    [self configureSegmentedControl];
    [self configureBarButtonItem];
    [self addDismissPopoverGestureToNavigationBar];
    [self addSVPullToRefreshForViewController];
}
/*
 当单击导航栏时，隐藏分类选择弹出控制器categoryListPopoverController
 */
- (void)addDismissPopoverGestureToNavigationBar
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopver:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer];
}

- (void)dismissPopver:(UITapGestureRecognizer *)recognizer
{
    [self.categoryListPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - 定制视图样式

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor blackColor]];
}

- (void)configureSegmentedControl
{
    static const CGFloat kSegmentedControlWidth = 500.0f;
    CGRect currentBounds = self.featureSegmentControl.bounds;
    self.featureSegmentControl.bounds = CGRectMake(currentBounds.origin.x, currentBounds.origin.y, kSegmentedControlWidth, currentBounds.size.height);
    self.featureSegmentControl.selectedFont = [UIFont systemFontOfSize:20.0f];
    self.featureSegmentControl.selectedFontColor = [UIColor whiteColor];
    self.featureSegmentControl.deselectedFont = [UIFont systemFontOfSize:20.0f];
    self.featureSegmentControl.deselectedFontColor = [UIColor grayColor];
    self.featureSegmentControl.selectedColor = [UIColor alizarinColor];
    self.featureSegmentControl.highlightedColor = [UIColor pomegranateColor];
    self.featureSegmentControl.deselectedColor = [UIColor clearColor];
    self.featureSegmentControl.dividerColor = [UIColor clearColor];
    self.featureSegmentControl.cornerRadius = 0.0f;
    self.featureSegmentControl.apportionsSegmentWidthsByContent = YES;

    
}

- (void)configureBarButtonItem
{
    [self.categoryBarButtonItem configureFlatButtonWithColor:[UIColor alizarinColor]
                                            highlightedColor:[UIColor pomegranateColor]
                                                cornerRadius:3.0f];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    [shadow setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSShadowAttributeName:shadow};
    //    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName:[UIColor clearColor],NSShadowAttributeName:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)]};
    [self.categoryBarButtonItem setTitleTextAttributes:textAttributes
                                              forState:UIControlStateNormal];
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
    self.categoryBarButtonItem.title = category.title;
    [self reloadPhotoStreamFeature:self.photoStream.feature category:category.value];
}

#pragma mark - Storyboard Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kSegueIdentifierCategoryPopover]) {
        //如果存在HooCategoryListViewController我们就不弹出，而是隐藏它
        if (self.categoryListPopoverController) {
            [self.categoryListPopoverController dismissPopoverAnimated:YES];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSegueIdentifierCategoryPopover]) {
        self.categoryListPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        [self configurePopover];
        HooCategoryListViewController *categoryListViewController = [segue destinationViewController];
        categoryListViewController.delegate = self;
    }
}


#pragma mark - IBAction

- (IBAction)featureChanged:(id)sender {
    NSInteger selectedSegmentIndex = [self.featureSegmentControl selectedSegmentIndex];
    PXAPIHelperPhotoFeature selectedFeature = [self.photoStreamFeatures[selectedSegmentIndex] integerValue];
    [self reloadPhotoStreamFeature:selectedFeature
                          category:self.photoStream.category];
}
@end
