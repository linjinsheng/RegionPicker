//
//  FSRegionModel.h
//  FSIPM
//
//  Created by nickwong on 16/5/23.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSRegionModel : NSObject

@property (nonatomic,copy) NSString *regionId;
@property (nonatomic,copy) NSString *regionName;
@property (nonatomic,copy) NSString *supRegionId;

@end
