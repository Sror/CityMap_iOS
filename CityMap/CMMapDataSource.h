//
//  CMMapDataSource.h
//  CityMap
//
//  Created by LittleDoorBoard on 13/5/12.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CMMapDataSource : NSObject

+ (CMMapDataSource *)sharedDataSource;

- (void)reloadLocationData;

@property (nonatomic, strong, readonly) NSArray *annotations;

@end
