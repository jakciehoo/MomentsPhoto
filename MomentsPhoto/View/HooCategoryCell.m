//
//  HooCategoryCell.m
//  MomentsPhoto
//
//  Created by HooJackie on 15/7/17.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooCategoryCell.h"
#import "FlatUIKit.h"
#import "HooPhotoStreamCategory.h"

@implementation HooCategoryCell

- (void)awakeFromNib {
    // Initialization code
    [self configureFlatCellWithColor:[UIColor cloudsColor] selectedColor:[UIColor peterRiverColor] roundingCorners:UIRectCornerAllCorners];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
}

- (void)setCategory:(HooPhotoStreamCategory *)category
{
    self.textLabel.text = category.title;
    [self setSelected:category.isSelected];
}

//A Boolean value that indicates whether the cell is selected
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.isSelected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.font = [UIFont systemFontOfSize:17];
    }
}

@end
