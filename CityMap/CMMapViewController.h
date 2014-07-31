//
//  CMMapViewController.h
//  CityMap
//
//  Created by LittleDoorBoard on 13/5/12.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CMMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)reloadLocations:(id)sender;

@end
