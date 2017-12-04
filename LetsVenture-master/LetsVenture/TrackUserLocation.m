//
//  TrackUserLocation.m
//  Geolocation
//
//  Created by Utsav on 01/09/15.
//  Copyright (c) 2015 Utsav. All rights reserved.
//

#import "TrackUserLocation.h"

@implementation TrackUserLocation
@synthesize location;

-(id)init{
    self = [super init];
    if(self){

    self.location=[[CLLocationManager alloc]init];
    // Create the location manager if this object does not already have one.
        if([CLLocationManager locationServicesEnabled]){
        
            [self.location setDelegate:self];
    

            //location manager delegate is our self. we will get error here if dont synthesize location.
            
            [self.location setDesiredAccuracy:kCLLocationAccuracyBest];
            //self.location.desiredAccuracy=kCLLocationAccuracyBest;
            //k=constant, greater accuracy requires more time and power. Therefore it can be a battery drain because it has to keep sending and receiving constant updates.
    
            
            
            [self.location requestAlwaysAuthorization];
            
            
            // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
            if ([self.location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.location requestWhenInUseAuthorization];
            }
        
            [self.location setDistanceFilter:kCLDistanceFilterNone];
            // Set a movement threshold for new events.
            //distance filter is the property of the core location manager class. and its the minimum distance measured in meteres that the device has to move horizontally before an update event is generated. this means when DistanceFileterNone is used, we will be notified of all movements. and again thats going to eat more battery power but if you want more accuracy and constant updates then this is the property to set.
    
            [self.location startUpdatingLocation];
            //To start updating the location. so that starts the location manager sending and receving information based on movement. and this will use above assoined properties for desired accuracy and distance filter settings. when it receives information it notifies the delegate. and it is going to call some other methods(as you can see below: locationManager:didUpdateLocation is called when updation of location is done).
            
            
            
            
        }
        
        
        
        
    }
    return self;

}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
       // NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
       
        
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
         */
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.location requestAlwaysAuthorization];
    }
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
*/

//Reverse Geocoding: Here we are providing location coordinates and using internet connectivity we are finding location name.
- (void) findLocationName:(CLLocationCoordinate2D)coord{
    
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation=[[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    //Initialization so as to do reverGeolocation. |newLocation| is initialized with current location coordinates for which we need to find a name.
  //  self.tappedLocationLatitude=coord.latitude;
    
   // self.tappedLocationLongitude=coord.longitude;
    [reverseGeocoder reverseGeocodeLocation:newLocation
                          completionHandler:^(NSArray *placemarks, NSError *error) {
                              
        //use NSerror to throw error, display Alert*****************************************************
                              if(error==nil&&placemarks) {
                                  
                                  CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
                                  
                                  NSString *countryName = myPlacemark.country;
                                  NSString *cityName= myPlacemark.subAdministrativeArea;
                                  NSString *placemarkName=myPlacemark.name;
                                  NSString *administrativeArea=myPlacemark.administrativeArea;
                                  NSString *locality=myPlacemark.locality;

                                  NSString *tapName;
                                  if(placemarkName != NULL) {
                                        tapName=placemarkName;            //set placemarkerName as TagName
                                  }
                                  else if (locality != NULL){
                                      tapName=locality;               //set locality as TagName
                                  }
                                  else if (cityName!=NULL){
                                      tapName=cityName;                   //set cityName as TagName
                                  }
                                  else if (administrativeArea != NULL){
                                      tapName=administrativeArea;         //set administrativeArea as TagName
                                  }
                                  else if (countryName!=NULL){
                                      tapName=countryName;                //set locationName as TagName
                                  }
                                  
                                  //NSLog(@"%@",myannotation.title);
                                  //NSLog(@"%@",myannotation.subtitle);
                                  NSDictionary *tapNameDict=[[NSDictionary alloc]initWithObjectsAndKeys:tapName,@"tapName", nil];
                                  
                                  [[NSNotificationCenter defaultCenter]
                                   postNotificationName:@"Selected Location" object:nil                                         userInfo:tapNameDict];
                             }
                              else {
                                  //If any error is there like, Apple server not reponding or internet not working etc.
                                  NSLog(@"%@",error);
                                  if(placemarks!=nil)
                                      NSLog(@"%@",placemarks);
                                  NSDictionary *tapNameDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Not Found",@"tapName", nil];
                                  
                                  [[NSNotificationCenter defaultCenter]
                                   postNotificationName:@"Selected Location" object:nil                                         userInfo:tapNameDict];
                              
                                  
                              }
                          }];
}


//It is called only when location manager calls startUpdatingLocation.
//It continuously checks whether location is updated or not.
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    
    
  /*
    //check whether there is change in location or not. If changed then save it in the property
    if(newLocation.coordinate.latitude!=oldLocation.coordinate.latitude &&
       newLocation.coordinate.longitude!=oldLocation.coordinate.longitude) {
        
        self.currentLocationLatitude=[[NSString alloc]
                                      initWithFormat:@"%f", newLocation.coordinate.latitude];
        
        self.currentLocationLongitude=[[NSString alloc]
                                       initWithFormat:@"%f", newLocation.coordinate.longitude];
    }
    */
    
}

//This method is called automatically when there is error in updating location.
//Error in updation can be due to: Network related error or user denied the to use current location
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //When GPS OFF the set current location to nil, so that if 'Tag GPS' is tapped, we can display error connection
 //   [self setValue:nil forKey:@"currentLocationLatitude"];
 //   [self setValue:nil forKey:@"currentLocationLongitude"];
    
    //check why we are not able to update location.
    switch ([error code]) {
        case kCLErrorNetwork:
            NSLog(@"Check your network connection or that you are not in airplane mode");
            break;
        case kCLErrorDenied:
            NSLog(@"User has denied to use current location");
            break;
            
        default:
            NSLog(@"Unknown network error");
            break;
    }

    
  }


/*
//Our location manager Delegate is going to look for this method for when it gets update information. So when it gets a change in location, this method is run.

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    CLLocation *loc =[locations lastObject];
//    self.currentLocationLatitude=[[NSString alloc]initWithFormat:@"%f",loc.coordinate.latitude];
//    self.currentLocationLongitude=[[NSString alloc]initWithFormat:@"%f",loc.coordinate.longitude];
    
}
*/




@end
