//
//  HooCategoryCell.m
//  MomentsPhoto
//
//  Created by HooJackie on 14/7/17.
//  Copyright (c) 2014年 jackie. All rights reserved.
//

#import "HooCategoryCell.h"
#import "FlatUIKit.h"
#import "HooPhotoStreamCategory.h"

@implementation HooCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self configureFlatCellWithColor:[UIColor clearColor] selectedColor:[UIColor peterRiverColor] roundingCorners:UIRectCornerAllCorners];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:50];
    self.backgroundColor = [UIColor clearColor];
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code

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
