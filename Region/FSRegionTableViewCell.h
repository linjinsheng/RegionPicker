//
//  FSRegionTableViewCell.h
//  FSIPM
//
//  Created by nickwong on 16/5/23.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSRegionModel.h"

@interface FSRegionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *regionName;

@property (nonatomic, strong) FSRegionModel *model;
@end
