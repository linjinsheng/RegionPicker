//
//  FSRegionTableViewCell.m
//  FSIPM
//
//  Created by nickwong on 16/5/23.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "FSRegionTableViewCell.h"

@implementation FSRegionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _regionName = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 25)];
    _regionName.textColor = [UIColor blackColor];
    _regionName.backgroundColor = [UIColor clearColor];
    _regionName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_regionName];
}

- (void)setModel:(FSRegionModel *)model
{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    _regionName.text = _model.regionName;
}

@end
