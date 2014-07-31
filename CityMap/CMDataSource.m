//
//  CMDataSoucre.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMDataSource.h"

// Cache Keys
static NSString *CMDataSourceCacheKeyContinents = @"CMDataSource.Cache.Continents";
static NSString *CMDataSourceCacheKeyCountries = @"CMDataSource.Cache.%@.Countries";
static NSString *CMDataSourceCacheKeyCities = @"CMDataSource.Cache.%@.cities";

// Dictionary Keys
NSString * const CMDataSourceDictKeyCity = @"City";
NSString * const CMDataSourceDictKeyLocal = @"Local";
NSString * const CMDataSourceDictKeyContinent = @"Continent";
NSString * const CMDataSourceDictKeyCountry = @"Country";
NSString * const CMDataSourceDictKeyImage = @"Image";
NSString * const CMDataSourceDictKeyLatitude = @"Latitude";
NSString * const CMDataSourceDictKeyLongitude = @"Longitude";
NSString * const CMDataSourceDictKeyRegion = @"Region";

@interface CMDataSource ()

@end

@implementation CMDataSource

#pragma mark -
#pragma mark Object Lifecycle

+ (CMDataSource *)sharedDataSource {
    static dispatch_once_t once;
    static CMDataSource *sharedDataSource;
    dispatch_once(&once, ^ {
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
        cityList = [NSArray arrayWithContentsOfFile:path];
        
        cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Interfaces

- (void)refresh {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    cityList = [NSArray arrayWithContentsOfFile:path];
    
    [self cleanCache];
}

- (void)cleanCache {
    [cache removeAllObjects];
}

- (NSArray *)arrayWithContinents {
    NSArray *continents = [cache objectForKey:CMDataSourceCacheKeyContinents];
    
    if (!continents) {
        // Save countries into a set (remove duplicates result).
        NSMutableSet *continentsSet = [NSMutableSet set];
        for (NSDictionary *key in cityList)
            [continentsSet addObject:key[CMDataSourceDictKeyContinent]];
        
        // Convert set to array and sort the array.
        continents = [[continentsSet allObjects] sortedArrayUsingComparator:
                     ^NSComparisonResult(id obj1, id obj2) {
                         return [obj1 compare:obj2];
                     }];
        
        // Save the result into cache
        [cache setObject:continents forKey:CMDataSourceCacheKeyContinents];
    }
    
    return continents;
}

- (NSArray *)arrayWithCountryInContinents:(NSString *)continent {
    NSString *cacheKey = [NSString stringWithFormat:CMDataSourceCacheKeyCountries, continent];
    NSArray *resultCountries = [cache objectForKey:cacheKey];
    
    if (!resultCountries) {
        // Filter array
        resultCountries = [cityList filteredArrayUsingPredicate:
                        [NSPredicate predicateWithBlock:
                         ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                             NSDictionary *key = (NSDictionary *)evaluatedObject;
                             return [key[CMDataSourceDictKeyContinent] isEqualToString:continent];
                         }]];
        
        // Save countries into a set (remove duplicates result).
        NSMutableSet *countriesSet = [NSMutableSet set];
        for (NSDictionary *key in resultCountries)
            [countriesSet addObject:key[CMDataSourceDictKeyCountry]];
        
        // Convert set to array and sort the array.
        resultCountries = [[countriesSet allObjects] sortedArrayUsingComparator:
                      ^NSComparisonResult(id obj1, id obj2) {
                          return [obj1 compare:obj2];
                      }];
        
        // Save the result into cache
        [cache setObject:resultCountries forKey:cacheKey];
    }
    
    return resultCountries;
}

- (NSArray *)arrayWithCityInCountries:(NSString *)country {
    NSString *cacheKey = [NSString stringWithFormat:CMDataSourceCacheKeyCities, country];
    NSArray *resultCities = [cache objectForKey:cacheKey];
    
    if (!resultCities) {
        // Filter array
        resultCities = [cityList filteredArrayUsingPredicate:
                           [NSPredicate predicateWithBlock:
                            ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                NSDictionary *key = (NSDictionary *)evaluatedObject;
                                return [key[CMDataSourceDictKeyCountry] isEqualToString:country];
                            }]];
        // Sort array
        resultCities = [resultCities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[CMDataSourceDictKeyCountry] compare:obj2[CMDataSourceDictKeyCountry]];
        }];
        
        // Save the result into cache
        [cache setObject:resultCities forKey:cacheKey];
    }
    
    return resultCities;
}

- (NSString *)stringWithContinentAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSString *continent = [self arrayWithContinents][row];
    return continent;
}

- (NSDictionary *)dictionaryWithCityAtIndexPath:(NSIndexPath *)indexPath InContinent:(NSString *)continent{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NSString *country = [self arrayWithCountryInContinents:continent][section];
    NSDictionary *city = [self arrayWithCityInCountries:country][row];
    return city;
}

@end
