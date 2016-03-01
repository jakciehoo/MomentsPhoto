//
//  HooFeatureViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/24.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooFeatureListViewController.h"
#import "PXAPI.h"
#import "UIViewController+RESideMenu.h"
#import "HooMainCollectionViewController.h"

@interface HooFeatureListViewController ()

@property (nonatomic, strong) NSArray *photoStreamFeatures;
@property (nonatomic, strong) NSArray *features;
@property (strong, readwrite, nonatomic) UITableView *tableView;


@end

@implementation HooFeatureListViewController


#pragma mark - 懒加载
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

- (NSArray *)features
{
    if (!_features) {
        _features = @[NSLocalizedString(@"Popular", @"高清美图") ,NSLocalizedString(@"Editors", @"经典推荐"),NSLocalizedString(@"Upcoming",@"近期"),NSLocalizedString(@"FreshToday",@"新鲜出炉")];
    }
    return _features;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor colorWithRed:213/255.0 green:92/255.0 blue:75/255.0 alpha:0.8];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HooMainCollectionViewController"]];
    
    [self.sideMenuViewController hideMenuViewController];
    NSInteger featureIndex = [self.photoStreamFeatures[indexPath.row] integerValue];
    NSString *featureName = self.features[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(featureListViewController:didSelectedfeature:featureName:)]) {
        [self.delegate featureListViewController:self didSelectedfeature:featureIndex featureName:featureName];
    }
    
    

}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.photoStreamFeatures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    
    
    cell.textLabel.text = self.features[indexPath.row];
    
    return cell;
}




@end
