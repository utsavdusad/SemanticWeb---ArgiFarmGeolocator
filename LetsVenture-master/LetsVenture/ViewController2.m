//
//  ViewController2.m
//  LetsVenture
//
//  Created by Utsav Dusad on 11/21/17.
//  Copyright © 2017 Utsav Dusad. All rights reserved.
//

#import "ViewController2.h"
#import "CropInfoTableViewController.h"
#import <MONActivityIndicatorView.h>
#import <AFNetworking.h>

#define SERVER_PREFIX @"https://1ad4b8jxh7.execute-api.us-west-2.amazonaws.com/dev/items"

@interface ViewController2 () <GMSMapViewDelegate,MONActivityIndicatorViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, strong) NSMutableDictionary *location_dictionary;
@property (weak, nonatomic) IBOutlet MONActivityIndicatorView *indicatorView;

@end

@implementation ViewController2


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
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate=self;
    self.mapView.settings.myLocationButton=TRUE;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveEvent:) name:@"New Location" object:nil];
    [self updateSubmitButton];
    self.indicatorView.delegate = self;
    self.indicatorView.numberOfCircles = 3;
    self.indicatorView.radius = 20;
    self.indicatorView.internalSpacing = 3;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.5;
    
  }

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)receiveEvent:(NSNotification *)notification {
    double  lat = [[[notification userInfo] valueForKey:@"latitude"] doubleValue];
    double  lon = [[[notification userInfo] valueForKey:@"longitude"] doubleValue];
    [self.location_dictionary setValue:[NSNumber numberWithDouble:lat] forKey:@"latitude"];
    [self.location_dictionary setValue:[NSNumber numberWithDouble:lon] forKey:@"longitude"];
    [self.location_dictionary setValue:[[notification userInfo] valueForKey:@"name"]  forKey:@"name"];
    [self.location_dictionary setValue:[[notification userInfo] valueForKey:@"countryName"]  forKey:@"countryName"];
    
    self.navigationController.title=[[notification userInfo] valueForKey:@"name"];
    CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(lat, lon);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [self.mapView clear];
        GMSMarker *marker=[GMSMarker markerWithPosition:coord];
        marker.map=self.mapView;
        marker.title=[self.location_dictionary valueForKey:@"name"];
        marker.snippet=[self.location_dictionary valueForKey:@"countryName"];
        self.title=marker.title;

        [self.mapView setSelectedMarker:marker];
        self.mapView.camera=[[GMSCameraPosition alloc] initWithTarget:coord zoom:self.mapView.camera.zoom bearing:self.mapView.camera.bearing viewingAngle:self.mapView.camera.viewingAngle];
        
    }];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    // For a random background color for a particular circle
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
//            self.searchBar.text=marker.title;
        } else if(response.firstResult.locality!=nil){
            
            marker.title=response.firstResult.locality;
            marker.snippet=response.firstResult.country;
//            self.searchBar.text=marker.title;
        } else if(response.firstResult.administrativeArea!=nil){
            
            marker.title=response.firstResult.administrativeArea;
            marker.snippet=response.firstResult.country;
//            self.searchBar.text=marker.title;
        } else if(response.firstResult.country!=nil){
            marker.title=response.firstResult.country;
//            self.searchBar.text=marker.title;
            
        } else {
            marker.title=@"Not Found";
        }
        //     marker.snippet=response.firstResult.subLocality;
     [self.location_dictionary setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
        [self.location_dictionary setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
                [self.location_dictionary setValue:marker.title forKey:@"name"];
        [self updateSubmitButton];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             self.title=marker.title;
         }];
        [self.mapView setSelectedMarker:marker]; 

        
    }];
    
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




- (IBAction)submitLocation:(id)sender {
    
   
    [self.indicatorView startAnimating];
          
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
             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            CropInfoTableViewController *vc = (CropInfoTableViewController *)[mainStoryboard
                                                                              instantiateViewControllerWithIdentifier:@"CropInfoTableViewController"];
            
            vc.city=[self.location_dictionary valueForKey:@"name"];
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
          
          
//    [[self.location_dictionary valueForKey:@"longitude"] doubleValue]);
//    
//    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    CropInfoTableViewController *vc = (CropInfoTableViewController *)[mainStoryboard
//                                                                      instantiateViewControllerWithIdentifier:@"CropInfoTableViewController"];
//    
//        vc.city=[self.location_dictionary valueForKey:@"name"];
////    [self dismissViewControllerAnimated:YES completion:nil];
//    
////    [self presentViewController:vc animated:NO completion:nil];
//    [self.navigationController pushViewController:vc animated:NO];
    
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
