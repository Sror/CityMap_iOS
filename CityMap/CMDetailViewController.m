//
//  CMDetailViewController.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMDetailViewController.h"
#import "CMDataSource.h"

@interface CMDetailViewController ()

- (void)accessFacebookAccountWithPermission:(NSArray *)permissions Handler:(void (^)(ACAccount *account))handler;

@end

@implementation CMDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cityname.text = self.title = self.city[CMDataSourceDictKeyCity];
    self.localname.text = self.city[CMDataSourceDictKeyLocal];
    self.countrynameNcontinentname.text = [NSString stringWithFormat:@"%@ , %@",
                                           self.city[CMDataSourceDictKeyCountry],
                                           self.city[CMDataSourceDictKeyContinent]];
    self.latitude.text = self.city[CMDataSourceDictKeyLatitude];
    self.longitude.text = self.city[CMDataSourceDictKeyLongitude];
    self.region.text = self.city[CMDataSourceDictKeyRegion];
    
    UIImage *image = [UIImage imageNamed:self.city[CMDataSourceDictKeyImage]];
    self.image.image = image;
    
    self.initialText = [NSString stringWithFormat: @"%@ (%@)\n%@", self.title, self.localname.text, self.countrynameNcontinentname.text];
}

- (IBAction)share:(id)sender {
    NSArray *items = @[self.initialText, self.image.image];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"%@: %@", completed?@"Success":@"Failed", activityType);
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Method

- (void)accessFacebookAccountWithPermission:(NSArray *)permissions Handler:(void (^)(ACAccount *account))handler {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
#warning Change to your facebook app id
    NSDictionary *facebookRequestOptions = @{
                                             ACFacebookAppIdKey: @"",
                                             ACFacebookPermissionsKey: permissions,
                                             ACFacebookAudienceKey: ACFacebookAudienceOnlyMe,
                                             };
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:facebookRequestOptions
                                       completion:^(BOOL granted, NSError *error) {
                                           if (granted) {
                                               NSArray *accounts = [accountStore
                                                                    accountsWithAccountType:facebookAccountType];
                                               ACAccount *account = [accounts lastObject];
                                               if (handler) handler(account);
                                           } else {
                                               NSLog(@"Auth Error: %@", [error localizedDescription]);
                                           }
                                       }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // We use SLComposer here. This will post on behalf of iOS or OS X.
    
    NSString *serviceType = nil;
    if (buttonIndex==0) {
        // Facebook
        serviceType = SLServiceTypeFacebook;
    } else if (buttonIndex==1) {
        // Twitter
        serviceType = SLServiceTypeTwitter;
    } else {
        return;
    }
    
    if (buttonIndex==0 || buttonIndex==1) {
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composer setInitialText:self.initialText];
        [composer addImage:self.image.image];
        composer.completionHandler = ^(SLComposeViewControllerResult result) {
            NSString *title = nil;
            if (result==SLComposeViewControllerResultCancelled) title = @"Post canceled";
            else if (result==SLComposeViewControllerResultDone) title = @"Post sent";
            else title = @"Unknown";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        };
        [self presentViewController:composer animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
