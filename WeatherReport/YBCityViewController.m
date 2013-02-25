//
//  YBCityViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-20.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBCityViewController.h"
#import "YBUtils.h"

@interface YBCityViewController ()
{
    NSMutableArray *data;
    NSMutableArray *AllCity;
    YBUtils *utils;
}
@end

@implementation YBCityViewController
@synthesize searchBar = _searchBar;

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
    data = [[NSMutableArray alloc] init];
    utils = [[YBUtils alloc] init];
    [utils Load];
    [utils LoadFavoriteCitys];
    AllCity = utils.AllCitys;
   
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchBar.delegate = self;
    self.title=@"添加城市";
    self.tableView.tableHeaderView = self.searchBar; 
   
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text=@"";
    [data removeAllObjects];
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [data removeAllObjects];
    
    for (NSDictionary *_city in AllCity) {
        
        if ([_city[@"cityname"] hasPrefix:searchBar.text]) {
            [data addObject:_city];
        }
    }
    
   // [self.searchBar resignFirstResponder];
    [self.tableView reloadData];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [data removeAllObjects];
    
    for (NSDictionary *_city in AllCity) {
       
        if ([_city[@"cityname"] hasPrefix:searchBar.text]) {
            [data addObject:_city];
        }
    }
    
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    NSString *cityname = data[indexPath.row][@"cityname"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:cityname delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [self.searchBar resignFirstResponder];
    [alert show];
    [utils SaveFavoriteCitys:data[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    // Configure the cell...
    NSDictionary *_c = data[indexPath.row];
    if (_c) {
        cell.textLabel.text = _c[@"cityname"];
    }
    return cell;
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


@end
