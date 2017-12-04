//
//  ViewController.h
//  LetsVenture
//
//  Created by Utsav Dusad on 10/29/17.
//  Copyright © 2017 Utsav Dusad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;




@end
