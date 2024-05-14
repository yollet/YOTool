//
//  YOLocationTool.h
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.

//  通用定位器

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YOLocationBlock)(CLLocation *location, CLPlacemark *address);
typedef void(^YOFieldLocationBlock)(CLLocationManager *manager, NSError *error);

@interface YOLocationTool : NSObject

@property (nonatomic, copy) YOLocationBlock locationBlock;
@property (nonatomic, copy) YOFieldLocationBlock fieldBlock;

- (void)locationWithBlock:(YOLocationBlock)block field:(YOFieldLocationBlock)field;

- (void)startLocation;
- (void)stopLocation;

@end

NS_ASSUME_NONNULL_END
