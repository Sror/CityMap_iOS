//
//  CMMapDataSource.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/5/12.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMMapDataSource.h"
#import <CoreLocation/CoreLocation.h>

@interface CMMapDataSource () {
    NSArray *cities;
    NSMutableArray *annotations;
}

@end

@implementation CMMapDataSource

+ (CMMapDataSource *)sharedDataSource {
    static CMMapDataSource *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init { 
    if (self = [super init]) {
        annotations = [NSMutableArray array];
        [self reloadLocationData];
    }
    return self;
}

- (void)reloadLocationData {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // Find plist from files from documents dir
    NSString *cityPlistFile = [docPath stringByAppendingPathComponent:@"citylist.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cityPlistFile]) {
        // There's no such file in doc dir. Use default one in bundle
        cityPlistFile = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    }
    
    // Load cities in
    cities = [NSArray arrayWithContentsOfFile:cityPlistFile];
    
    // Remove old annotations
    [annotations removeAllObjects];
    
    // Create them as annotations
    for (NSDictionary *city in cities) {
        // Extend MKPointAnnotation or Design a class which conforms to MKAnnotation protocol
        // to save your extra dataC
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationDegrees latitude = [city[@"Latitude"] doubleValue];
        CLLocationDegrees longitude = [city[@"Longitude"] doubleValue];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = city[@"City"];
        annotation.subtitle = city[@"Country"];
        [annotations addObject:annotation];
    }
}

- (NSArray *)annotations {
    return [NSArray arrayWithArray:annotations];
}

@end
