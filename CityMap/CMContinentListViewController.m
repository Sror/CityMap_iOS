//
//  CMContinentListVielwControllerViewController.m
//  CityMap
//
//  Created by LittleDoorBoard on 13/4/6.
//  Copyright (c) 2013年 tw.edu.nccu. All rights reserved.
//

#import "CMContinentListViewController.h"
#import "CMCityListViewController.h"
#import "CMContinentListCell.h"
#import "CMDataSource.h"

@interface CMContinentListViewController ()

@end

@implementation CMContinentListViewController
/*
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CMDataSource sharedDataSource] arrayWithContinents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContinentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];


    // Fetch country data by index path from continent list
    NSString *continent = [[CMDataSource sharedDataSource] stringWithContinentAtIndexPath:indexPath];

    // Assign values to views in cell
    CMContinentListCell *continentCell = (CMContinentListCell *)cell;
    continentCell.continentname.text = continent;

    // Another simple way to find views by their tags, if tags of views are set.
    //UILabel *airportNameLabel = (UILabel *)[cell viewWithTag:1001];
    //UILabel *iataLabel = (UILabel *)[cell viewWithTag:1002];
    //airportNameLabel.text = airport[APDataSourceDictKeyShortName];
    //iataLabel.text = airport[APDataSourceDictKeyIATA];

    return cell;
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    if ([segue.identifier isEqualToString:@"showCities"]) {
        // Fetch data by index path from data source
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *continent = [[CMDataSource sharedDataSource] stringWithContinentAtIndexPath:indexPath];
        
        // Feed data to the destination of the segue
        CMCityListViewController *CityListPage = segue.destinationViewController;
        CityListPage.continent = continent;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//}

@end
