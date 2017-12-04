//
//  ViewController.m
//  LetsVenture
//
//  Created by Utsav Dusad on 10/29/17.
//  Copyright © 2017 Utsav Dusad. All rights reserved.
//

#import "ViewController.h"
#import "LVDictionary.h"
#import "XMLReader.h"
#import "MZFormSheetPresentationViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"
#import "ViewController.h"




@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GMSMapViewDelegate>{

    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightContraint;
@property (strong) NSArray *fileteredData;
@property (strong) NSArray *filteredTempData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;

@property (strong) NSDate *date;
@property (nonatomic, strong) NSMutableDictionary *location_dictionary;


@end



@implementation ViewController

-(NSMutableDictionary *)location_dictionary{
    if(_location_dictionary!=nil){
        return _location_dictionary;
    }

    _location_dictionary=[[NSMutableDictionary alloc] init];
    
    return _location_dictionary;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchBar.delegate=self;
    self.searchBar.placeholder=@"Enter place name...";
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
self.navigationController.navigationBar.topItem.title = @"AgriFarm GeoLocator";
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    self.tableViewHeightContraint.constant=self.tableView.contentSize.height;
        
    [self.view layoutIfNeeded];
    }];

    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate=self;
    self.mapView.settings.myLocationButton=TRUE;
    

//    CalendarView *calendarView = [[CalendarView alloc] initWithPosition:10.0 y:10.0];
//    [self.calendarView addSubview:calendarView];
 
    [self updateSubmitButton];
    
   
}

-(void)updateSubmitButton{
    
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    if(!_location_dictionary){
        
        self.submitButton.enabled=NO;
    }else{
        
        self.submitButton.enabled=YES;
    }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}
//- (IBAction)showCalender:(id)sender {
//
//    UINavigationController *navigationController = [self formSheetControllerWithNavigationController];
//    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
//
//    formSheetController.presentationController.backgroundColor = [UIColor clearColor];
//
////    formSheetController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
//    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
//    formSheetController.presentationController.blurEffectStyle = UIBlurEffectStyleLight;
//    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//
//    [self presentViewController:formSheetController animated:YES completion:nil];
//
//    calendarView = [[CalendarView alloc] initWithPosition:10.0 y:10.0];
//    calendarView.shouldShowHeaders=true;
//    calendarView.calendarDelegate=self;
//    [formSheetController.view addSubview:calendarView];
//
//
//
//
//}
//- (UINavigationController *)formSheetControllerWithNavigationController {
//    return [self.storyboard instantiateViewControllerWithIdentifier:@"formSheetController"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didChangeCalendarDate:(NSDate *)date
{
    NSLog(@"didChangeCalendarDate:%@", date);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (tableView == self.searchDisplayController.searchResultsTableView) {
    //        return [searchResults count];
    //
    //    } else {
    //        return [recipes count];
    //    }
    
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
            
            description.text=[NSString stringWithFormat:@"%@, %@",[data valueForKey:@"adminName1"],[data valueForKey:@"countryName"]];
            
            
        }else{
            
            NSDictionary *data=[_fileteredData objectAtIndex:indexPath.row];
            
            NSString *wordName=[data valueForKey:@"name"];
            //            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            word.text=wordName;
              description.text=[NSString stringWithFormat:@"%@, %@",[data valueForKey:@"adminName1"],[data valueForKey:@"countryName"]];
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
        self.location_dictionary=nil;
        [self updateSubmitButton];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
      
            [self.tableView reloadData];
            self.tableViewHeightContraint.constant=self.tableView.contentSize.height;
            
            [self.view layoutIfNeeded];
            
            
        }];
        
    }else if(searchText.length>=1){
        
        _filteredTempData=nil;
        
        
        
        
        NSString *stringURL=[NSString stringWithFormat:@"http://api.geonames.org/searchJSON?name_startsWith=%@&maxRows=10&username=utsavdusad",searchText];
        
        
        //1
        NSURL *url = [NSURL URLWithString:
                      stringURL];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(data){
            
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
            
//                self.tableViewHeightContraint.constant=30;
//                [self.view layoutIfNeeded];
                 [self.tableView reloadData];
                NSInteger count=[[jsonArray valueForKey:@"geonames"] count];
                if(count>3){
                     
                   self.tableViewHeightContraint.constant=3*30;
                }else{
                    
                     self.tableViewHeightContraint.constant=count*30;
                }
                
                
                [self.view layoutIfNeeded];
               
               
            }];
            }
            
        }];
        
        
        [dataTask resume];
        
        
    } else {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.word contains[c] %@", searchText];
        
        
        
        //        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",self.searchText.text];
        _filteredTempData = [_fileteredData filteredArrayUsingPredicate:resultPredicate];
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
            [self.tableView reloadData];
            self.tableViewHeightContraint.constant=self.tableView.contentSize.height;
            
            [self.view layoutIfNeeded];
            
            
        }];
        
        
        
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        
        
        _fileteredData=[NSArray arrayWithObject:[_fileteredData objectAtIndex:indexPath.row]];
        
        double latitude=[[[_fileteredData objectAtIndex:0] valueForKey:@"lat"] doubleValue];
        double longitude=[[[_fileteredData objectAtIndex:0] valueForKey:@"lng"] doubleValue];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
        
        CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(latitude, longitude);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            GMSMarker *marker=[GMSMarker markerWithPosition:coord];
            marker.map=self.mapView;
            marker.title=[[_fileteredData objectAtIndex:0] valueForKey:@"name"];
            marker.snippet=[[_fileteredData objectAtIndex:0] valueForKey:@"countryNamel"];
            [self.mapView setSelectedMarker:marker];
        }];
        //fetch data from NSUserDefaults
        
        
        
        
        self.mapView.camera=[[GMSCameraPosition alloc] initWithTarget:coord zoom:self.mapView.camera.zoom bearing:self.mapView.camera.bearing viewingAngle:self.mapView.camera.viewingAngle];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            [self updateSubmitButton];
            
            
        }];
        
    }
    @catch ( NSException *e ) {
       
        _fileteredData=nil;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            [self updateSubmitButton];
            
            
        }];
        
        
        
    }
    @finally{
        
      
        
        
        
    }
   
    
    
    

}


- (void)didChangeCalendarDate:(NSDate *)date withType:(NSInteger)type withEvent:(NSInteger)event{

    NSLog(@"Test");
    
}
- (void)didDoubleTapCalendar:(NSDate *)date withType:(NSInteger)type{
    NSLog(@"Test");
//    if(type==0){
//        [calendarView setMode:2];
//
//    }else if(type==1){
//
//        [calendarView setMode:0];
//    }else{
//
//        [calendarView setMode:1];
//    }

    
}







//******************************************
//Description: Called when we tap on the map. Here we first display a pin on the tapped location and find name for the tapped location. For new tag we intend to show default marker. so we pass we a flag "isDefaultMarker" which creates a default marker.
//Used: Used when TAP GPS is tapped.
//Last date modified: 9th Nov 2016
-(void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
     [self.mapView clear];
    GMSMarker *marker=[GMSMarker markerWithPosition:coordinate];
    marker.map=self.mapView;
    
    [self reverseGeocoding:coordinate withMarker:marker];

    
}


////******************************************
////Description: This method gets the human-readable address for the selected marker.
////thoroughfare: Street number and name.
////locality: Locality or city.
//// subLocality: Subdivision of locality, district or park.
////administrativeArea: Region/State/Administrative area.
////postalCode: Postal/Zip code.
////country: The country name.
////Last date modified: 9th Nov 2016
-(void)reverseGeocoding:(CLLocationCoordinate2D) coordinate withMarker:(GMSMarker *)marker{


    GMSGeocoder *geocoder =[GMSGeocoder geocoder];

    [geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {

        //  GMSMarker *marker=[GMSMarker markerWithPosition:coordinate];



//        if(response.firstResult.thoroughfare!=nil){
//            marker.title=response.firstResult.thoroughfare;
//            marker.snippet=response.firstResult.locality;
//            self.searchBar.text=marker.title;
//        } else
        if(response.firstResult.subLocality!=nil){

            marker.title=response.firstResult.subLocality;
            marker.snippet=response.firstResult.locality;
            self.searchBar.text=marker.title;
        } else if(response.firstResult.locality!=nil){

            marker.title=response.firstResult.locality;
            marker.snippet=response.firstResult.country;
            self.searchBar.text=marker.title;
        } else if(response.firstResult.administrativeArea!=nil){

            marker.title=response.firstResult.administrativeArea;
            marker.snippet=response.firstResult.country;
            self.searchBar.text=marker.title;
        } else if(response.firstResult.country!=nil){
            marker.title=response.firstResult.country;
            self.searchBar.text=marker.title;

        } else {
            marker.title=@"Not Found";
        }
        //     marker.snippet=response.firstResult.subLocality;

        
        [self.location_dictionary setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
        [self updateSubmitButton];
        
        [self.mapView setSelectedMarker:marker];
        


  


    }];

}
- (IBAction)submitLocation:(id)sender {
    
    NSLog(@"Lcatitude: %f   Longitude: %f", [[self.location_dictionary valueForKey:@"latitude"] doubleValue], [[self.location_dictionary valueForKey:@"longitude"] doubleValue]);
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController *vc = (ViewController *)[mainStoryboard
                                                    instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
    
}


@end
