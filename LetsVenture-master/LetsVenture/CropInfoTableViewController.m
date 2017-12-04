//
//  CropInfoTableViewController.m
//  LetsVenture
//
//  Created by Utsav Dusad on 11/12/17.
//  Copyright © 2017 Utsav Dusad. All rights reserved.
//

#import "CropInfoTableViewController.h"

@interface CropInfoTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation CropInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.data=[[NSMutableArray alloc] init];
    NSDictionary *dict1=[[NSDictionary alloc] initWithObjectsAndKeys:@"January",@"month",@"Rice, Wheat, Corn",@"description", nil];
    NSDictionary *dict2=[[NSDictionary alloc] initWithObjectsAndKeys:@"February",@"month",@"Apple, Rice",@"description", nil];
        NSDictionary *dict3=[[NSDictionary alloc] initWithObjectsAndKeys:@"March",@"month",@"Wheat, Corn",@"description", nil];
        NSDictionary *dict4=[[NSDictionary alloc] initWithObjectsAndKeys:@"April",@"month",@"Maze, Apple, Rice, Wheat, Corn",@"description", nil];
        NSDictionary *dict5=[[NSDictionary alloc] initWithObjectsAndKeys:@"May",@"month",@"Rice, Wheat, Corn",@"description", nil];
        NSDictionary *dict6=[[NSDictionary alloc] initWithObjectsAndKeys:@"June",@"month",@"Berries, Corn",@"description", nil];
        NSDictionary *dict7=[[NSDictionary alloc] initWithObjectsAndKeys:@"July",@"month",@"Rice, Wheat, Corn",@"description", nil];
        NSDictionary *dict8=[[NSDictionary alloc] initWithObjectsAndKeys:@"August",@"month",@"Spinach",@"description", nil];
        NSDictionary *dict9=[[NSDictionary alloc] initWithObjectsAndKeys:@"September",@"month",@"Barley",@"description", nil];
        NSDictionary *dict10=[[NSDictionary alloc] initWithObjectsAndKeys:@"November",@"month",@"Mint, Potatoes, Tomatoes",@"description", nil];
        NSDictionary *dict11=[[NSDictionary alloc] initWithObjectsAndKeys:@"November",@"month",@"Tomatoes",@"description", nil];
        NSDictionary *dict12=[[NSDictionary alloc] initWithObjectsAndKeys:@"December",@"month",@"Oranges",@"description", nil];
    [self.data addObject:dict1];
    [self.data addObjectsFromArray:@[dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9,dict10,dict11,dict12]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+[self.data count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>=2){
        NSArray *arr=[self.dataValue objectAtIndex:indexPath.row-2];
        if([arr count]<=3){
            return 40;
            
        }else if([arr count]<=6){
            return 80;
            
        }if([arr count]<=9){
            return 100;
            
        }else{
            
            return 120;
        }
        
    }else{
        
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.row==0){
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"YearCell" forIndexPath:indexPath];
        
             UILabel *placeName=(UILabel *)[cell viewWithTag:20];
        placeName.text=self.city;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }else if(indexPath.row==1){
         cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
        UILabel *month=(UILabel *)[cell viewWithTag:10];
        
        UILabel *description=(UILabel *)[cell viewWithTag:20];
        
        NSDictionary *temp=[self.data objectAtIndex:indexPath.row-2];
        month.text=[temp valueForKey:@"month"];
          month.numberOfLines = 2;
        
        NSArray *arr=[self.dataValue objectAtIndex:indexPath.row-2];
        NSString *tempo=[NSString stringWithFormat:@""];
        for(int i=0;i<[arr count];i++){
            if(i>=1){
                 tempo=[tempo stringByAppendingString:@", "];
                
            }
            tempo=[tempo stringByAppendingString:[NSString stringWithFormat:@"%@",arr[i]]];
        }
        
//        description.text=[temp valueForKey:@"description"];
        if([arr count]==0){
            description.text=@"No suitable crops";
            
        }else{
         description.text=tempo;
        }
        description.numberOfLines = 8;
        
    }
    

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
