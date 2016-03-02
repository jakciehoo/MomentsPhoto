//
//  HooCategoryListViewController.m
//  MomentsPhoto
//
//  Created by HooJackie on 14/7/17.

//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooCategoryListViewController.h"
#import "FlatUIKit.h"
#import "HooPhotoStreamCategoryList.h"
#import "HooCategoryCell.h"
#import "HooPhotoStreamCategory.h"

static NSString *resuseIdentifier = @"CategoryCell";

@interface HooCategoryListViewController ()
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation HooCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - self.view.bounds.size.height/4 ) / 2.0f, self.view.frame.size.width, self.view.bounds.size.height/3) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.alpha = 0.5;
        tableView.backgroundColor = [UIColor colorWithRed:213/255.0 green:92/255.0 blue:75/255.0 alpha:0.8];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        //[tableView registerClass:[HooCategoryCell class] forCellReuseIdentifier:resuseIdentifier];
        tableView;
    });
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor clearColor];
    
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
    [[HooPhotoStreamCategoryList DefaultList] removeAllCategories];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[HooPhotoStreamCategoryList DefaultList] categoryCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HooCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (cell == nil) {
        cell = [[HooCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
    }
    
    HooPhotoStreamCategory *category = [[HooPhotoStreamCategoryList DefaultList] categoryAtIndex:indexPath.row];
    cell.category = category;

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
