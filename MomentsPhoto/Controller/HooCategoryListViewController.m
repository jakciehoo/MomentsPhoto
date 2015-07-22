//
//  HooCategoryListViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooCategoryListViewController.h"
#import "FlatUIKit.h"
#import "HooPhotoStreamCategoryList.h"
#import "HooCategoryCell.h"
#import "HooPhotoStreamCategory.h"

static NSString *resuseIdentifier = @"CategoryCell";

@interface HooCategoryListViewController ()

@end

@implementation HooCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor cloudsColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUInteger selectedIndex = [[HooPhotoStreamCategoryList DefaultList] indexOfSelectedCategory];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:YES animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[HooPhotoStreamCategoryList DefaultList] removeAllCategories];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[HooPhotoStreamCategoryList DefaultList] categoryCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HooCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier forIndexPath:indexPath];
    
    HooPhotoStreamCategory *category = [[HooPhotoStreamCategoryList DefaultList] categoryAtIndex:indexPath.row];
    cell.category = category;
    
    if (category.isSelected) {
        NSLog(@"%ld",(long)indexPath.row);
    }
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HooPhotoStreamCategoryList *categoryList = [HooPhotoStreamCategoryList DefaultList];
    UITableViewCell *cell = nil;
    NSUInteger selectedIndex = [categoryList indexOfSelectedCategory];
    
    if (selectedIndex == indexPath.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
     cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    [cell setSelected:NO animated:YES];

    
    [categoryList selectCategoryAtIndex:indexPath.row];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
    
    [self.delegate categoryListViewController:self didSelectedCategory:[categoryList categoryAtIndex:indexPath.row]];
}


@end
