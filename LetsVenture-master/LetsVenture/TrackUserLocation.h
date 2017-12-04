//
//  TrackUserLocation.h
//  Geolocation
//
//  Created by Utsav on 01/09/15.
//  Copyright (c) 2015 Utsav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>




//This class is used to get current location of the user.
@interface TrackUserLocation : NSObject <CLLocationManagerDelegate>


@property (strong,nonatomic)  CLLocationManager *location;

//@property (nonatomic) double tappedLocationLatitude;
//@property (nonatomic) double tappedLocationLongitude;

- (void) findLocationName:(CLLocationCoordinate2D)coord;
@end
