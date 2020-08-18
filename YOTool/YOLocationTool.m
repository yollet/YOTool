//
//  YOLocationTool.m
//  YOTool
//
//  Created by jhj on 2020/8/18.
//  Copyright © 2020 jhj. All rights reserved.
//

#import "YOLocationTool.h"
#import "UIViewController+YOTool.h"

@interface YOLocationTool () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation YOLocationTool

#pragma mark -- 开始定位并赋值 --
- (void)locationWithBlock:(YOLocationBlock)block field:(YOFieldLocationBlock)field;
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 10.0;
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationBlock = block;
        self.fieldBlock = field;
        [self startLocation];
    }
}

#pragma mark -- 定位成功 --
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self stopLocation];
    
    CLLocation *myLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    NSMutableArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [geoCoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            if (self.locationBlock) {
                self.locationBlock(myLocation, placemark);
            }
            NSLog(@"经度 == %f, 纬度 == %f =============================", myLocation.coordinate.longitude, myLocation.coordinate.latitude);
            NSLog(@"all == %@ =============================", placemark.addressDictionary);
            NSLog(@"administrativeArea == %@ =============================", placemark.administrativeArea);
            NSLog(@"subAdministrativeArea == %@ =============================", placemark.subAdministrativeArea);
            NSLog(@"postalCode == %@ =============================", placemark.postalCode);
            NSLog(@"ISOcountryCode == %@ =============================", placemark.ISOcountryCode);
            NSLog(@"country == %@ =============================", placemark.country);
            NSLog(@"inlandWater == %@ =============================", placemark.inlandWater);
            NSLog(@"ocean == %@ =============================", placemark.ocean);
            NSLog(@"areasOfInterest == %@ =============================", placemark.areasOfInterest);
        }
    }];

}

#pragma mark -- 定位失败 --
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (!self.fieldBlock) {
        self.fieldBlock(manager, error);
    }
}

#pragma mark -- 开始定位 --
- (void)startLocation
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark -- 停止定位 --
- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}

@end
