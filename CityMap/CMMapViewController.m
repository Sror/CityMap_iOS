//
//  CMMapViewController.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/5/12.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMMapViewController.h"
#import "CMMapDataSource.h"
#import "CMDetailViewController.h"
#import "CMDataSource.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface CMMapViewController ()

@end

@implementation CMMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.mapView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Load annotations
    [self reloadLocations:nil];
    
    // Let line breaks when text is too long
    self.addressLabel.numberOfLines = 0;
    
    self.infoView.alpha = 0.0f;
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Leave the UserLocation annotation default style
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    NSString * const ReuseIdentifier = @"PinAnnotation";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
    }
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)annotationView;
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id<MKAnnotation> annotation = view.annotation;
    CMDetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailView"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    NSArray *cityList = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *dic in cityList)
        if ([dic[CMDataSourceDictKeyCity] isEqualToString:annotation.title ]) {
            detailview.city = dic;
        }
    
    [self.navigationController pushViewController: detailview animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Find address
    [UIView animateWithDuration:.3f animations:^{
        self.infoView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.addressLabel.text = nil;
        [self.loadingIndicator startAnimating];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationCoordinate2D coord = view.annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                CLPlacemark *placemark = placemarks[0];
                NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);
                // Address may contains "line-break". Replace it with ","
                address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
                [self.loadingIndicator stopAnimating];
                self.addressLabel.text = address;
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [UIView animateWithDuration:.3f animations:^{
        self.infoView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.addressLabel.text = nil;
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50000, 50000);
    [mapView setRegion:region animated:YES];
}

#pragma mark - actions

- (IBAction)reloadLocations:(id)sender {
    [[CMMapDataSource sharedDataSource] reloadLocationData];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[[CMMapDataSource sharedDataSource] annotations]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
