//
//  ViewController.m
//  LetsVenture
//
//  Created by Utsav Dusad on 29/07/16.
//  Copyright © 2016 Utsav Dusad. All rights reserved.
//

#import "SearchTableViewController.h"
#import "LVDictionary.h"
#import "XMLReader.h"

@interface SearchTableViewController () <UISearchBarDelegate>

@property (strong) NSArray *fileteredData;
@property (strong) NSArray *filteredTempData;

@property (strong) UISearchController *searchVC;


@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    self.searchBar.delegate=self;

    
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(_fileteredData){
        if(_filteredTempData){
          return  [_filteredTempData count];
        }
    
        return [_fileteredData count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
    [self configureCell:cell atIndexPath:indexPath];
    }];
    // Display recipe in the table cell
//    Recipe *recipe = nil;
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        recipe = [searchResults objectAtIndex:indexPath.row];
//    } else {
//        recipe = [recipes objectAtIndex:indexPath.row];
//    }
//    
//    cell.nameLabel.text = recipe.name;
//    cell.thumbnailImageView.image = [UIImage imageNamed:recipe.image];
//    cell.prepTimeLabel.text = recipe.prepTime;
    
    return cell;
}


-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{

     UILabel *word=(UILabel *)[cell viewWithTag:10];
     UITextView *description=(UITextView *)[cell viewWithTag:20];
    UIButton *button=(UIButton *)[cell viewWithTag:30];
    
    [button addTarget:self
               action:@selector(bookmarkWord:) forControlEvents:UIControlEventTouchDown];
        
    
    if(_fileteredData){
        if(_filteredTempData){

            NSDictionary *data=[_filteredTempData objectAtIndex:indexPath.row];
            
            NSString *wordName=[data valueForKey:@"name"];
//            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            word.text=wordName;
//            description.text=[data valueForKey:@"description"];
            
        
        }else{
        
            NSDictionary *data=[_fileteredData objectAtIndex:indexPath.row];
            
            NSString *wordName=[data valueForKey:@"name"];
//            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            word.text=wordName;
//            description.text=[data valueForKey:@"description"];
            
        }

        
    }
        
 

}



-(void)bookmarkWord:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    
    
    if(_fileteredData){
        if(_filteredTempData){
            
            NSDictionary *data=[_filteredTempData objectAtIndex:indexPath.row];
            
            NSString *wordName=[data valueForKey:@"name"];
            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [[LVDictionary alloc] insertIntoDictionary:[NSDictionary dictionaryWithObjectsAndKeys:result,@"name",@"empty",@"description", nil]];
            
            
        }else{
            
            NSDictionary *data=[_fileteredData objectAtIndex:indexPath.row];
            
            NSString *wordName=[data valueForKey:@"name"];
            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [[LVDictionary alloc] insertIntoDictionary:[NSDictionary dictionaryWithObjectsAndKeys:result,@"name",@"empty",@"description", nil]];
            
        }
        
        
    }

    
    
}



#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{

    NSLog(@"BookMark clicked");
    _fileteredData=nil;
    _filteredTempData=nil;
    _fileteredData=[[LVDictionary alloc] getAllDictionary];
    
    [self.tableView reloadData];
    
    

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    
    if(searchText.length==0){
        _fileteredData=nil;
        _filteredTempData=nil;
        
    }else if(searchText.length>=1){

        _filteredTempData=nil;
        
        
        
        NSString *stringURL=[NSString stringWithFormat:@"http://api.geonames.org/searchJSON?name_startsWith=%@&maxRows=10&username=utsavdusad",searchText];
        
        
        //1
        NSURL *url = [NSURL URLWithString:
                      stringURL];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
        
        
            NSError *error2 = nil;
     
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//
//            NSError *parseError = nil;
//            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:responseString error:&parseError];
//            NSLog(@" %@", [[xmlDictionary valueForKey:@"geonames"] valueForKey:@"geoname"]);
//
            
        
            if([[jsonArray valueForKey:@"geonames"] count]==0){
                
                _fileteredData=nil;
            }else{
            _fileteredData=[NSArray arrayWithArray:[jsonArray valueForKey:@"geonames"]];
            }
//            if(self.searchBar.text.length>1){
//                [self searchBar:self.searchBar textDidChange:self.searchBar.text];
//
//            }
            
            
            
            
            
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
            [self.tableView reloadData];
            }];
            
        }];
        
        
        [dataTask resume];
        
    
    } else {
    
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.word contains[c] %@", searchText];
    
        
        
//        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",self.searchText.text];
        _filteredTempData = [_fileteredData filteredArrayUsingPredicate:resultPredicate];
        
        
        [self.tableView reloadData];
        
    
    
    }
        


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _fileteredData=[NSArray arrayWithObject:[_fileteredData objectAtIndex:indexPath.row]];
     [self.tableView reloadData];
    
}


@end
