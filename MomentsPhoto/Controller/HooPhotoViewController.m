//
//  HooPhotoViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/16.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooPhotoViewController.h"
#import "HooPhoto.h"
#import "MBProgressHUD.h"
#import "HooPhotoInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImageView+WebCache.h"

static NSTimeInterval const kResizeAnimationDuration = 0.5f;
static NSTimeInterval const kPresentAndDismissAnimationDuration = 1.0f;
static NSString * const kSegueIdentifierInfoPopover = @"showInfoPopover";
static float const kAlphaValue = 0.8f;

@interface HooPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewCenterYContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewCenterXConstraint;

@property (weak, nonatomic) IBOutlet UIView *tooView;

// Top and leading layout constraints are used for animation purposes.
@property (nonatomic, strong) NSLayoutConstraint *topLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leadingLayoutConstraint;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panToDismissGestureRecognizer;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapToShrinkGestureRecognizer;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapToHideToolViewGestureRecognizer;


@property (nonatomic, weak) UIView *rootView;


@property (nonatomic, strong) UIView *sender;

@property (nonatomic, strong) HooPhoto *photo;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) BOOL isShowSmall;
@property (nonatomic ,assign) BOOL isToolViewVisible;

@end

@implementation HooPhotoViewController
@synthesize doubleTapToShrinkGestureRecognizer = _doubleTapToShrinkGestureRecognizer;
@synthesize tapToHideToolViewGestureRecognizer = _tapToHideToolViewGestureRecognizer;
@synthesize panToDismissGestureRecognizer = _panToDismissGestureRecognizer;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tooView.layer.cornerRadius = 10.0;
}


#pragma mark - pan手势退出
//pan关闭此视图（HooPhotoViewController）
- (UIPanGestureRecognizer *)panToDismissGestureRecognizer
{
    if (!_panToDismissGestureRecognizer) {
        _panToDismissGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanToDismiss:)];
        _panToDismissGestureRecognizer.minimumNumberOfTouches = 1;
        _panToDismissGestureRecognizer.maximumNumberOfTouches = 5;
        
    }
    return _panToDismissGestureRecognizer;

}

- (void)handlePanToDismiss:(UIPanGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateRecognized == sender.state) {
        [self.view removeGestureRecognizer:sender];
        [self dismiss];
    }
}

#pragma mark - 单击隐藏或显示toolView
- (UITapGestureRecognizer *)tapToHideToolViewGestureRecognizer
{
    if (!_tapToHideToolViewGestureRecognizer) {
        _tapToHideToolViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToHideToolView:)];
        _tapToHideToolViewGestureRecognizer.numberOfTapsRequired = 1;
        [_tapToHideToolViewGestureRecognizer requireGestureRecognizerToFail:_doubleTapToShrinkGestureRecognizer];
        // So the user can still interact with controls in the view.
        _tapToHideToolViewGestureRecognizer.cancelsTouchesInView = NO;
    }
    return _tapToHideToolViewGestureRecognizer;
}
- (void)handleTapToHideToolView:(UITapGestureRecognizer *)sender
{
    

            if(UIGestureRecognizerStateRecognized == sender.state && !_isShowSmall) {
                [UIView animateWithDuration:kPresentAndDismissAnimationDuration animations:^{

                    self.tooView.alpha = _isToolViewVisible ? 0.0 : kAlphaValue;
                    _isToolViewVisible = !_isToolViewVisible;

                }];
            }

}
#pragma mark - 双击放大火缩小图片视图

- (UITapGestureRecognizer *)doubleTapToShrinkGestureRecognizer
{
    if (!_doubleTapToShrinkGestureRecognizer) {
        _doubleTapToShrinkGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToShinkView:)];
        _doubleTapToShrinkGestureRecognizer.numberOfTapsRequired = 2;
        // So the user can still interact with controls in the view.
        _doubleTapToShrinkGestureRecognizer.cancelsTouchesInView = NO;
    }
    return _doubleTapToShrinkGestureRecognizer;

}

- (void)handleTapToShinkView:(UITapGestureRecognizer *)doubleTap
{
    // 原始大小
    CGSize photoSize = self.imageView.image.size;
    
    // 缩放后比率
    CGFloat scaleFactor = [self scaleFactorToAspectFitPhotoWithSize:photoSize];
    
    // 缩放后的尺寸
    CGSize scaledPhotoSize = CGSizeMake(floorf(photoSize.width * scaleFactor),
                                        floorf(photoSize.height * scaleFactor));
    if (!self.isShowSmall) {
        self.contentViewWidthLayoutConstraint.constant = scaledPhotoSize.width;
        self.contentViewHeightLayoutConstraint.constant = scaledPhotoSize.height;
        self.isShowSmall = true;
        
        [UIView animateWithDuration:kResizeAnimationDuration animations:^{
            [self.view layoutIfNeeded];
            self.tooView.alpha = 0.0;
        }];
    }else{
        self.contentViewWidthLayoutConstraint.constant = self.view.bounds.size.width;
        self.contentViewHeightLayoutConstraint.constant = self.view.bounds.size.height;
        self.isShowSmall = false;
        
        [UIView animateWithDuration:kResizeAnimationDuration animations:^{
            [self.view layoutIfNeeded];
            self.tooView.alpha = kAlphaValue;
        }];
    }


}

//加载视图到窗口中
- (void)presentWithWindow:(UIWindow *)window photo:(HooPhoto *)photo sender:(UIView *)sender
{
    self.rootView = window.rootViewController.view;
    [self synchronizeWithRootView];
    [window addSubview:self.view];
    self.photo = photo;
    self.sender = sender;
    //显示小图
    [self displayThumbnail];
    
    [self performPresentAnimation];

}

// 让视图和我们的rooView视图（HooMainCollectionView.view）重叠
- (void)synchronizeWithRootView
{
    self.view.transform = self.rootView.transform;
    // Transform invalidates the frame, so use bounds and center instead.
    self.view.bounds = self.rootView.bounds;
    self.view.center = self.rootView.center;
}

- (void)dismiss
{
    // End layout constraints for the dismiss animation.
    [self setDismissAnimationEndLayoutConstraints];
    
    if (self.hud != nil) {
        [self.hud hide:true];
    }
    
    [UIView animateWithDuration:kPresentAndDismissAnimationDuration animations:^{
        // Fade out the dim view and the content view.
        self.dimView.alpha = 0.0f;
        self.contentView.alpha = 0.0f;
        self.tooView.alpha = 0.0;
        // Tell the view to perform layout, so that constraints changes will be animated.
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // Reset the layout constraints for the next presentation.
        [self resetLayoutConstraints];
        
        [self.view removeFromSuperview];
        
    }];
}

#pragma mark - Present and Dismiss Animations

/*
 显示图片动画
 */
- (void)performPresentAnimation
{
    // 设置起始约束
    [self setPresentAnimationStartLayoutConstraints];
    
    // 立即改变视图的约束
    [self.view layoutIfNeeded];
    
    // End animation layout constraints.
    [self setPresentAnimationEndLayoutConstraints];
    
    // Dimming view and content view will have a fade-in animation.
    self.dimView.alpha = 0.0f;
    self.contentView.alpha = 0.0f;
    
    // Perform the animation.
    [UIView animateWithDuration:kPresentAndDismissAnimationDuration animations:^{
        self.dimView.alpha = 0.6f;
        self.contentView.alpha = 1.0f;
        
        // Tell the view to perform layout, so that constraints changes will be animated.
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // Add tap to dismiss gesture only after the animation is completed.
        // Otherwise, user can dismiss the view in the middle of an animation.
        [self.view addGestureRecognizer:self.doubleTapToShrinkGestureRecognizer];
        [self.view addGestureRecognizer:self.panToDismissGestureRecognizer];
        [self.imageView addGestureRecognizer:self.tapToHideToolViewGestureRecognizer];
        
        
        // First animation completed. Chain the second animation to
        // load and display photo.
        [self displayPhoto];
    }];
}





- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attribute
                                       constant:(CGFloat)constant
{
    NSParameterAssert(NSLayoutAttributeTop == attribute || NSLayoutAttributeLeading == attribute);
    
    UIView *contentView = self.contentView;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentView);
    
    NSString *orientation = (attribute == NSLayoutAttributeTop) ? @"V" : @"H";
    NSString *format = [[NSString alloc] initWithFormat:@"%@:|-(%.2f)-[contentView]", orientation, constant];
    
    NSArray *layoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    
    NSAssert([layoutConstraints count] == 1, @"There should only be one layout constraint in the array when creating the constraints array from VFL.");
    return layoutConstraints[0];
}

/*
 通过改变约束确定动画起始位置
 */
- (void)setPresentAnimationStartLayoutConstraints
{
    // 设置起始大小
    CGRect senderRect = [self.view convertRect:self.sender.bounds fromView:self.sender];
    
    // 临时去除X,Y对其
    [self.view removeConstraints:@[self.contentViewCenterXConstraint,
                                   self.contentViewCenterYContraint]];
    
    // 设置左右约束 大小约束
    self.leadingLayoutConstraint = [self constraintWithAttribute:NSLayoutAttributeLeading
                                                        constant:senderRect.origin.x];
    self.topLayoutConstraint = [self constraintWithAttribute:NSLayoutAttributeTop
                                                    constant:senderRect.origin.y];
    [self.view addConstraints:@[self.topLayoutConstraint,
                                self.leadingLayoutConstraint]];
    
    self.contentViewWidthLayoutConstraint.constant = senderRect.size.width;
    self.contentViewHeightLayoutConstraint.constant = senderRect.size.height;
    
    // 刷新视图约束
    [self.view setNeedsUpdateConstraints];
}

/*
 确定动画结束位置
 */
- (void)setPresentAnimationEndLayoutConstraints
{

    // 原始大小
    CGSize photoSize = self.imageView.image.size;
    
    // 缩放后比率
    CGFloat scaleFactor = [self scaleFactorToAspectFitPhotoWithSize:photoSize];
    
    // 缩放后的尺寸
    CGSize scaledPhotoSize = CGSizeMake(floorf(photoSize.width * scaleFactor),
                                        floorf(photoSize.height * scaleFactor));
    self.contentViewWidthLayoutConstraint.constant = scaledPhotoSize.width;
    self.contentViewHeightLayoutConstraint.constant = scaledPhotoSize.height;
    
    // Content view will be centered horizontally and vertically within its superview.
    [self.view removeConstraints:@[self.topLayoutConstraint,
                                   self.leadingLayoutConstraint]];
    [self.view addConstraints:@[self.contentViewCenterXConstraint,
                                self.contentViewCenterYContraint]];
    
    // Let the view know that we've modified the constraints.
    [self.view setNeedsUpdateConstraints];
}

/*
 设置关闭视图的位置，用于关闭动画
 */
- (void)setDismissAnimationEndLayoutConstraints
{
    // The dismiss animation is the reverse of the present animation.
    // So the start of the present animation is the end of the dismiss animation.
    [self setPresentAnimationStartLayoutConstraints];
}

/*
重置约束
 */
- (void)resetLayoutConstraints
{
    [self.view removeConstraints:@[self.topLayoutConstraint,
                                   self.leadingLayoutConstraint]];
    
    [self.view addConstraints:@[self.contentViewCenterXConstraint,
                                self.contentViewCenterYContraint]];
}

#pragma mark - View Rotation Events


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [UIView animateWithDuration:kResizeAnimationDuration animations:^{
        [self synchronizeWithRootView];
        
        // Resize view to aspect fit photo as rotation changes the view's bounds.
        [self sizeToAspectFitPhotoAnimated:NO];
        
        // We need to re-layout the views, otherwise our views will be out of place.
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - View Rotation Events

// When the root view controller's view runs its rotation animation, we will also
// match its rotation animation for a smoother transition.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self synchronizeWithRootView];
        
        // Resize view to aspect fit photo as rotation changes the view's bounds.
        [self sizeToAspectFitPhotoAnimated:NO];
        
        // We need to re-layout the views, otherwise our views will be out of place.
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Display Photo Details on View

// 显示小图
- (void)displayThumbnail
{

    
    UIImage *thumbnail = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.photo.thumbnailURL absoluteString]];
    self.imageView.image = thumbnail;
}

// 显示大图，如果缓存存在则直接加载，否则从网上下载大图
- (void)displayPhoto
{
    UIImage *photoImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[self.photo.photoURL absoluteString]];
    
    // If photo is in memory cache, we can just display the image immediately.
    // Else we will have to load the photo in asynchronously.
    if (photoImage) {
        self.imageView.image = photoImage;
        [self sizeToAspectFitPhotoAnimated:YES];
    } else {
        [self loadPhoto];
    }
}

// Load the photo asynchronously and display it on the image view.
- (void)loadPhoto
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];
    
    // We'll display the low resolution thumbnail as a placeholder while we
    // load the larger size photo in the background.
    UIImage *thumbnail = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.photo.thumbnailURL absoluteString]];
    
    // Load image asynchronously from network or disk cache.
    [self.imageView sd_setImageWithURL:self.photo.photoURL placeholderImage:thumbnail options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
        if (image) {
            if (self.hud != nil) {
                [MBProgressHUD hideHUDForView:self.imageView animated:YES];
            }
            [self sizeToAspectFitPhotoAnimated:YES];
        } else if (error) {
            NSLog(@"[SDWebImage Error] - %@", [error localizedDescription]);
        }
    }];
}

#pragma mark - Resize to Aspect Fit Photo within Screen

/*
 改变contentView视图大小匹配照片
 */
- (void)sizeToAspectFitPhotoAnimated:(BOOL)animated
{
    //判断图片是否加载，如果没有加载，则不需要调整大小。
    if (!self.imageView.image) {
        return;
    }

    
    // 原始大小
    CGSize photoSize = self.imageView.image.size;
    
    // 缩放后比率
    CGFloat scaleFactor = [self scaleFactorToAspectFitPhotoWithSize:photoSize];
    
    // 缩放后的尺寸
    CGSize scaledPhotoSize = CGSizeMake(floorf(photoSize.width * scaleFactor),
                                        floorf(photoSize.height * scaleFactor));
    
    // 动画调整视图大小
    if (animated) {
        // Animating NSLayoutConstraints:
        // http://stackoverflow.com/a/12926646
        // http://stackoverflow.com/q/12622424
        
        self.contentViewWidthLayoutConstraint.constant = self.view.bounds.size.width;
        self.contentViewHeightLayoutConstraint.constant = self.view.bounds.size.height;
         [UIView animateWithDuration:kResizeAnimationDuration animations:^{
             [self.view layoutIfNeeded];
             self.tooView.alpha = kAlphaValue;
         }];
        
    } else {
        self.contentViewWidthLayoutConstraint.constant = scaledPhotoSize.width;
        self.contentViewHeightLayoutConstraint.constant = scaledPhotoSize.height;
        self.tooView.alpha = kAlphaValue;

    }

}

// 设置视图到窗口的最小边距
static CGFloat const kViewToWindowPadding = 60.0f;

/*
   计算图片比率
 */
- (CGFloat)scaleFactorToAspectFitPhotoWithSize:(CGSize)photoSize
{
    // 视图大小
    CGSize viewSize = self.rootView.bounds.size;
    
    // Include a padding space, so that scaled view will not be too close to
    // the window's edge.
    CGSize photoWithPaddingSize = CGSizeMake(photoSize.width + kViewToWindowPadding,
                                             photoSize.height + kViewToWindowPadding);
    
    // 图片宽度调整比率，默认为1.0
    CGFloat widthScaleFactor = 1.0f;
    if (photoWithPaddingSize.width > viewSize.width) {
        widthScaleFactor = viewSize.width / photoWithPaddingSize.width;
    }
    
    // 图片高度调整比率，默认为1.0
    CGFloat heightScaleFactor = 1.0f;
    if (photoWithPaddingSize.height > viewSize.height) {
        heightScaleFactor = viewSize.height / photoWithPaddingSize.height;
    }
    
    // 取宽高调整比率中比率较小的值
    return fminf(widthScaleFactor, heightScaleFactor);
}
#pragma mark - toolView事件
- (IBAction)savePhoto:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
                                              contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}
#pragma mark 分享功能
- (IBAction)sharePhoto:(UIButton *)sender {

    NSURL *imageUrl = self.photo.photoURL;
    NSString *imageString = [imageUrl absoluteString];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"丁丁美图分享"
                                       defaultContent:@"正在使用丁丁美图(For iPad)分享看到的好看的美图"
                                                image:[ShareSDK imageWithData:imageData fileName:imageString mimeType:@"jpg"]
                                                title:@"正在使用丁丁美图分享看到的美图！"
                                                  url:@"http://weibo.com/hooyoo"
                                          description:@"来自丁丁美图iPad版（MomentPhoto）"
                                            mediaType:SSPublishContentMediaTypeImage];
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUnknown];
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
    
}

- (IBAction)showInfo:(UIButton *)sender {
}

#pragma mark - Storyboard Segues



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSegueIdentifierInfoPopover]) {
        //UIPopoverController *popC = [(UIStoryboardPopoverSegue *)segue popoverController];
        HooPhotoInfoViewController *info = [segue destinationViewController];
        info.pTitle = self.photo.title;
        info.uName = self.photo.userFullName;
    }
}



@end
