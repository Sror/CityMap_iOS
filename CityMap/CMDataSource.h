//
//  CMDataSoucre.h
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CMDataSourceDictKeyCity;
extern NSString * const CMDataSourceDictKeyLocal;
extern NSString * const CMDataSourceDictKeyContinent;
extern NSString * const CMDataSourceDictKeyCountry;
extern NSString * const CMDataSourceDictKeyImage;
extern NSString * const CMDataSourceDictKeyLatitude;
extern NSString * const CMDataSourceDictKeyLongitude;
extern NSString * const CMDataSourceDictKeyRegion;

@interface CMDataSource : NSObject {
    // Main data pool
    NSArray *cityList;
    // Cache data pool
    NSCache *cache;
}

+ (CMDataSource *)sharedDataSource;

- (void)refresh;
- (void)cleanCache;
- (NSArray *)arrayWithContinents;
- (NSArray *)arrayWithCountryInContinents:(NSString *)continent;
- (NSArray *)arrayWithCityInCountries:(NSString *)country;
- (NSString *)stringWithContinentAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)dictionaryWithCityAtIndexPath:(NSIndexPath *)indexPath InContinent:(NSString *)continent;

@end
