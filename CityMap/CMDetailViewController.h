//
//  CMDetailViewController.h
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface CMDetailViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSString *initialText;

@property (strong, nonatomic) IBOutlet UILabel *cityname;
@property (strong, nonatomic) IBOutlet UILabel *localname;
@property (strong, nonatomic) IBOutlet UILabel *countrynameNcontinentname;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *region;
@property (strong, nonatomic) IBOutlet UIImageView *image;

- (IBAction)share:(id)sender;

@end
