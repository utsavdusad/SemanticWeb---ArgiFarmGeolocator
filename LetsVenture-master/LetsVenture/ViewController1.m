//
//  ViewController1.m
//  LetsVenture
//
//  Created by Utsav Dusad on 11/21/17.
//  Copyright © 2017 Utsav Dusad. All rights reserved.
//

#import "ViewController1.h"
#import "CropInfoTableViewController.h"
#import "SingleCropTableViewController.h"
#import <AFNetworking.h>
#import <MONActivityIndicatorView.h>
#define SERVER_PREFIX @"https://1ad4b8jxh7.execute-api.us-west-2.amazonaws.com/dev/items"

@interface ViewController1 () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MONActivityIndicatorViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightContraint;
@property (strong) NSArray *fileteredData;
@property (strong) NSArray *filteredTempData;
@property (strong) NSArray *cropData;
@property (strong) NSArray *cropTempData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchCropBar;
@property (weak, nonatomic) IBOutlet UITableView *cropTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cropTableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet MONActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableDictionary *location_dictionary;

@end

@implementation ViewController1

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
    self.searchBar.tag=1;
    self.searchBar.placeholder=@"Enter place name...";
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tag=1;
    
    self.cropTableView.delegate=self;
    self.cropTableView.dataSource=self;
    self.cropTableView.tag=2;
    self.navigationController.navigationBar.topItem.title = @"AgriFarm GeoLocator";
    
    
    self.searchCropBar.delegate=self;
    self.searchCropBar.tag=2;
    self.searchCropBar.placeholder=@"Enter Crop name...";
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.tableViewHeightContraint.constant=self.tableView.contentSize.height;
        self.cropTableViewHeightConstraint.constant=self.cropTableView.contentSize.height;
    
        [self.view layoutIfNeeded];
    }];
    
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_background.jpg"]]];
//    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"app_background.jpg"].CGImage);
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_background.jpg"]]];
    UIImage *img=[UIImage imageNamed:@"Ap.png"];
    [self.imageView setImage:img];
//    [self.imageView setBackgroundColor:[UIColor redColor]];
    
    [self updateSubmitButton];
//    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.delegate = self;
    self.indicatorView.numberOfCircles = 3;
    self.indicatorView.radius = 20;
    self.indicatorView.internalSpacing = 3;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.5;
//    self.indicatorView.center = CGPointMake(self.view.window.frame.size.width/2+50, self.view.window.frame.size.height/2+300);
//    [self.view addSubview:self.indicatorView];

    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(tableView.tag==1){
    if(_fileteredData){
        if(_filteredTempData){
            return  [_filteredTempData count];
        }
        
        return [_fileteredData count];
    }
    
    return 0;
        
    }else {
        
        if(_cropData){
            if(_cropTempData){
                return  [_cropTempData count];
            }
            
            return [_cropData count];
        }
        
        return 0;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1){
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        cell.tag=1;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"CropCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.tag=2;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self configureCell:cell atIndexPath:indexPath];
        }];
        
        return cell;
    }
}
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    // For a random background color for a particular circle
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    UILabel *word=(UILabel *)[cell viewWithTag:10];
    UILabel *description=(UILabel *)[cell viewWithTag:20];
//    UIButton *button=(UIButton *)[cell viewWithTag:30];
    
    if(cell.tag==1){
//    [button addTarget:self
//               action:@selector(bookmarkWord:) forControlEvents:UIControlEventTouchDown];
    
    
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
    }else{
        
        
        
        if(_cropData){
            if(_cropTempData){
                
                NSDictionary *data=[_cropTempData objectAtIndex:indexPath.row];
                
                NSString *wordName=[data valueForKey:@"name"];
                //            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                word.text=wordName;
                
                description.text=[NSString stringWithFormat:@"%@, %@",[data valueForKey:@"adminName1"],[data valueForKey:@"countryName"]];
                
                
            }else{
                
                NSString *data=[_cropData objectAtIndex:indexPath.row];
                
                NSString *wordName=data;
                //            NSString *result = [wordName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                word.text=wordName;
                //            description.text=[data valueForKey:@"description"];
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
}





#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
    
    NSLog(@"BookMark clicked");
    _fileteredData=nil;
    _filteredTempData=nil;
    _location_dictionary=nil;
    _cropTempData=nil;
    _cropData=nil;
    
    [self.tableView reloadData];
    [self.cropTableView reloadData];
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if(searchBar.tag==2){
        
        
        _fileteredData=nil;
        _filteredTempData=nil;
        _location_dictionary=nil;
        [self.searchBar setText:nil];
        
        if(searchBar.text.length==0){
            _cropData=nil;
            _cropTempData=nil;
            //            self.location_dictionary=nil;
            [self updateSubmitButton];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                [self.cropTableView reloadData];
                [self.tableView reloadData];
                self.cropTableViewHeightConstraint.constant=self.cropTableView.contentSize.height;
                self.tableViewHeightContraint.constant=0;
                [self.view layoutIfNeeded];
                
                
            }];
            
        }else if(searchBar.text.length>=1){
            [self.indicatorView startAnimating];
            _cropTempData=nil;
            
            
            
            NSMutableURLRequest *request;
            AFHTTPRequestSerializer *reqSerializer = [AFJSONRequestSerializer serializer];
            
            
            NSString *serverPath1=[SERVER_PREFIX stringByAppendingFormat:@"/"];
            
            request = [reqSerializer requestWithMethod:@"POST" URLString:serverPath1 parameters:nil error:nil];
            
            
            //        [request setValue:[_location_dictionary valueForKey:@"latitude"]forHTTPHeaderField:@"latitude"];
            //        [request setValue:[_location_dictionary valueForKey:@"longitude"] forHTTPHeaderField:@"longitude"];
            //
            NSDictionary *params = @ {
                @"cropDetails" :self.searchCropBar.text,
                
            };
            
            //        NSDictionary *params = @ {
            //            @"latitude" : @34,
            //            @"longitude" :@-118
            //
            //        };
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSURLSessionDataTask *task=[manager POST:SERVER_PREFIX parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if([responseObject count]>0 ){
                    
                    if([[responseObject firstObject] count]>0){
                    
                        _cropData=@[self.searchCropBar.text];
                    }else{
                                        _cropData=nil;
                        
                    }
                
                    
                }else{
                    
              
                _cropData=nil;
                  
                [self displayAlertForCropName:self.searchCropBar.text];
                    
                }
     
                
                
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    
                    [self.cropTableView reloadData];
                    [self.tableView reloadData];
                    NSInteger count=[responseObject count];
                    if(count>3){
                        
                        self.cropTableViewHeightConstraint.constant=3*40;
                    }else{
                        
                        self.cropTableViewHeightConstraint.constant=count*40;
                    }
                    
                    self.tableViewHeightContraint.constant=0;
                    [self.view layoutIfNeeded];
                    [self.indicatorView stopAnimating];
                    
                }];
           
            
                

                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                 [self.indicatorView stopAnimating];
            }];
            
            
            [task resume];
            
            
            
            
            
        }
        
        
    }
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self updateSubmitButton];

if(searchBar.tag==1){
    _cropData=nil;
    _cropTempData=nil;
    [self.searchCropBar setText:nil];
    
    
    if(searchText.length==0){
        _fileteredData=nil;
        _filteredTempData=nil;
        self.location_dictionary=nil;
        [self updateSubmitButton];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
            [self.tableView reloadData];
            [self.cropTableView reloadData];
            self.tableViewHeightContraint.constant=self.tableView.contentSize.height;
            self.cropTableViewHeightConstraint.constant=0;
            [self.view layoutIfNeeded];
            
            
        }];
        
    }else if(searchText.length>=1){
        
        _filteredTempData=nil;
        
       
        
        
        NSString *stringURL=[NSString stringWithFormat:@"http://api.geonames.org/searchJSON?name_startsWith=%@&maxRows=10&username=utsavdusad&country=US&country=IN&country=CA&country=GB",searchText];
        
        
        //1
        NSURL *url = [NSURL URLWithString:
                      stringURL];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(data){
                
                NSError *error2 = nil;
                
                NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];

                
                if([[jsonArray valueForKey:@"geonames"] count]==0){
                    
                    _fileteredData=nil;
                    _location_dictionary=nil;
                }else{
                    _fileteredData=[NSArray arrayWithArray:[jsonArray valueForKey:@"geonames"]];
                }

                
                
                
                
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
    
                    [self.tableView reloadData];
                    [self.cropTableView reloadData];
                    NSInteger count=[[jsonArray valueForKey:@"geonames"] count];
                    if(count>3){
                        
                        self.tableViewHeightContraint.constant=3*40;
                    }else{
                        
                        self.tableViewHeightContraint.constant=count*40;
                    }
                    self.cropTableViewHeightConstraint.constant=0;
                    
                    [self.view layoutIfNeeded];
                    
                    
                }];
            }else{
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                  
                    
                }];
                
            }
            
        }];
        
        
        [dataTask resume];
        
        
    }
    }else{
        
        if(searchText.length==0){
            
            _cropData=nil;
            _cropTempData=nil;
            self.location_dictionary=nil;
            [self updateSubmitButton];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                [self.tableView reloadData];
                [self.cropTableView reloadData];
                self.tableViewHeightContraint.constant=0;
                self.cropTableViewHeightConstraint.constant=0;
                [self.view layoutIfNeeded];
                
                
            }];
            
        }
        
        
        
    }
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==1){
    @try{
         _cropData=nil;
        _cropTempData=nil;

        _fileteredData=[NSArray arrayWithObject:[_fileteredData objectAtIndex:indexPath.row]];
        
        double latitude=[[[_fileteredData objectAtIndex:0] valueForKey:@"lat"] doubleValue];
        double longitude=[[[_fileteredData objectAtIndex:0] valueForKey:@"lng"] doubleValue];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
        [self.location_dictionary setValue:[[_fileteredData objectAtIndex:0] valueForKey:@"name"] forKey:@"name"];
        [self.location_dictionary setValue:[[_fileteredData objectAtIndex:0] valueForKey:@"countryName"] forKey:@"countryName"];
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"New Location" object:nil userInfo:self.location_dictionary];

        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            [self updateSubmitButton];
            [self.cropTableView reloadData];
            
            
        }];
        
    }
    @catch ( NSException *e ) {
        
        _fileteredData=nil;
        _location_dictionary=nil;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            [self updateSubmitButton];
            
            
        }];
        
        
        
    }
    @finally{
        
        
        
        
        
    }
    
    }else{
        
        @try{
            
            _fileteredData=nil;
            _filteredTempData=nil;
            _location_dictionary=nil;

            _cropData=[NSArray arrayWithObject:[_cropData objectAtIndex:indexPath.row]];
            
//            double latitude=[[[_cropData objectAtIndex:0] valueForKey:@"lat"] doubleValue];
//            double longitude=[[[_cropData objectAtIndex:0] valueForKey:@"lng"] doubleValue];
//            [self.location_dictionary setValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
//            [self.location_dictionary setValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
            [self.location_dictionary setValue:[_cropData objectAtIndex:0] forKey:@"name"];
//            [self.location_dictionary setValue:[[_cropData objectAtIndex:0] valueForKey:@"countryName"] forKey:@"countryName"];
//
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"New Location" object:nil userInfo:self.location_dictionary];

            
            
            //        self.mapView.camera=[[GMSCameraPosition alloc] initWithTarget:coord zoom:self.mapView.camera.zoom bearing:self.mapView.camera.bearing viewingAngle:self.mapView.camera.viewingAngle];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.cropTableView reloadData];
                [self.tableView reloadData];
                [self updateSubmitButton];
                
                
            }];
            
        }
        @catch ( NSException *e ) {
            
            _cropData=nil;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.cropTableView reloadData];
                [self updateSubmitButton];
                
                
            }];
            
            
            
        }
        @finally{
            
            
            
            
            
        }
        
        
        
    }
    
    
    
}







- (IBAction)submitLocation:(id)sender {
    
    NSLog(@"Lcatitude: %f   Longitude: %f", [[self.location_dictionary valueForKey:@"latitude"] doubleValue], [[self.location_dictionary valueForKey:@"longitude"] doubleValue]);
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
      [self.indicatorView startAnimating];
    if(_fileteredData){
        
        NSMutableURLRequest *request;
        AFHTTPRequestSerializer *reqSerializer = [AFJSONRequestSerializer serializer];
        

        NSString *serverPath1=[SERVER_PREFIX stringByAppendingFormat:@"/"];
        
        request = [reqSerializer requestWithMethod:@"POST" URLString:serverPath1 parameters:nil error:nil];

       NSDictionary *params = @ {
           @"latitude" :[NSNumber numberWithDouble:[[_location_dictionary valueForKey:@"latitude"] doubleValue]] ,
           @"longitude" :[NSNumber numberWithDouble:[[_location_dictionary valueForKey:@"longitude"] doubleValue]]

       };
        

        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSURLSessionDataTask *task=[manager POST:SERVER_PREFIX parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if([responseObject count]>0 ){
                
                CropInfoTableViewController *vc = (CropInfoTableViewController *)[mainStoryboard
                                                                                  instantiateViewControllerWithIdentifier:@"CropInfoTableViewController"];
                
                vc.city=[self.location_dictionary valueForKey:@"name"];
                //    [self dismissViewControllerAnimated:YES completion:nil];
                vc.dataValue=[NSArray arrayWithArray:responseObject];
                
                [self.navigationController pushViewController:vc animated:NO];
            }else{
                
                
                [self displayAlert];
                
            }
              [self.indicatorView stopAnimating];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
           [self.indicatorView stopAnimating];
        }];
        
    
        [task resume];
        
  
    }else if(_cropData){
        NSMutableURLRequest *request;
        AFHTTPRequestSerializer *reqSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSString *serverPath1=[SERVER_PREFIX stringByAppendingFormat:@"/"];
        
        request = [reqSerializer requestWithMethod:@"POST" URLString:serverPath1 parameters:nil error:nil];
        

        NSDictionary *params = @ {
            @"cropDetails" :self.searchCropBar.text,
            
        };

        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSURLSessionDataTask *task=[manager POST:SERVER_PREFIX parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if([responseObject count]>0 ){
                
                if([[responseObject firstObject] count]>0){
                SingleCropTableViewController *vc = (SingleCropTableViewController *)[mainStoryboard
                                                                                      instantiateViewControllerWithIdentifier:@"SingleCropTableViewController"];
                vc.cropName=[self.location_dictionary valueForKey:@"name"];
                vc.dataValue=[responseObject firstObject];
                [self.navigationController pushViewController:vc animated:NO];
                }else{
                    
                    [self displayAlertForCropName:self.searchCropBar.text];
                }
            }else{
                
                

                
            }
                          [self.indicatorView stopAnimating];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
             [self.indicatorView stopAnimating];
        }];
        
        
        [task resume];
        
        
        
        
        
        
        

        
        
    }
    
}

-(void)displayAlertForCropName:(NSString *)cropName{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = [UIViewController new];
        window.windowLevel = UIWindowLevelAlert + 1;
        
        NSString *message=[NSString stringWithFormat:@"Sorry, data not available for %@",cropName];
        UIAlertController* alertCtrl = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        

        UIAlertAction *okAction= [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            window.hidden = YES;
        }];
        [alertCtrl addAction:okAction];
        
        //http://stackoverflow.com/questions/25260290/makekeywindow-vs-makekeyandvisible
        [window makeKeyAndVisible]; //The makeKeyAndVisible message makes a window key, and moves it to be in front of any other windows on its level
        [window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    });
    
    
    
    
    
}
-(void)displayAlert{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = [UIViewController new];
        window.windowLevel = UIWindowLevelAlert + 1;
        
        NSString *message=[NSString stringWithFormat:@"Sorry, data not available for %@",[self.location_dictionary valueForKey:@"name"]];
        UIAlertController* alertCtrl = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        
        
        UIAlertAction *okAction= [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            window.hidden = YES;
        }];
        [alertCtrl addAction:okAction];
        
        //http://stackoverflow.com/questions/25260290/makekeywindow-vs-makekeyandvisible
        [window makeKeyAndVisible]; //The makeKeyAndVisible message makes a window key, and moves it to be in front of any other windows on its level
        [window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    });
    
    
}



@end
