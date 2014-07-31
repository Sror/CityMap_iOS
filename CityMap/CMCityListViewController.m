//
//  CMCityListViewController.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMCityListViewController.h"
#import "CMDetailViewController.h"
#import "CMCityListCell.h"
#import "CMDataSource.h"

@interface CMCityListViewController ()

@end

@implementation CMCityListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.continent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[CMDataSource sharedDataSource] arrayWithCountryInContinents:self.continent] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[CMDataSource sharedDataSource] arrayWithCountryInContinents:self.continent][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *country = [[CMDataSource sharedDataSource] arrayWithCountryInContinents:self.continent][section];
    return [[[CMDataSource sharedDataSource] arrayWithCityInCountries:country] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch country data by index path from continent list
    NSDictionary *city = [[CMDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:self.continent];
    
    // Assign values to views in cell
    CMCityListCell *cityCell = (CMCityListCell *)cell;
    cityCell.cityname.text = city[CMDataSourceDictKeyCity];
    cityCell.localname.text = city[CMDataSourceDictKeyLocal];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;

    if ([segue.identifier isEqualToString:@"showDetail"]) {

        // Fetch data by index path from data source
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *city = [[CMDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:self.continent];
        
        // Feed data to the destination of the segue
        CMDetailViewController *DetailPage = segue.destinationViewController;
        DetailPage.city = city;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
