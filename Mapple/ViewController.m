//
//  ViewController.m
//  Mapple
//
//  Created by Arthur Boia on 8/28/14.
//  Copyright (c) 2014 Arthur Boia. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h> 
@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>


// shane working now
@end

@implementation ViewController
{
    MKMapView * mapView;
    CLLocationManager * locationManager;
    CLLocation * location;
    UITableView * events;
    UILabel * spots;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height/2.0)];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    mapView.userTrackingMode = YES;
    [self.view addSubview:mapView];
    
    events = [[UITableView alloc]initWithFrame:CGRectMake(0, 320, 320, 320)];
    events.backgroundColor = [UIColor lightGrayColor];
    events.rowHeight = 100;
    events.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
    [self.view addSubview:events];

    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    
    // NSLog(@"%@", _venue);
    
    spots = [[UILabel alloc] initWithFrame:(CGRectMake(40,240, 240, 40))];
    spots.textColor = [UIColor whiteColor];
    spots.font = [UIFont fontWithName:@"HelveticaNeue"  size:20];
    spots.backgroundColor = [UIColor darkGrayColor];
    spots.text = [NSString stringWithFormat:@"%@", _venue[@"resultsPage"][@"result"]];
    [self.view addSubview: spots];

    

}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return;
//}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    for (location in locations) {
        
        NSString * parameters = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
        
        NSLog(@"hello");
        NSString* urlString =[NSString stringWithFormat:@"http://api.songkick.com/api/3.0/search/locations.json?location=geo:%@&apikey=o3MaOGhwkmxtNIDM", parameters];
        NSLog(@"%@", urlString);
        NSURL* url = [NSURL URLWithString:urlString];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        //    NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.songkick.com/api/3.0/search/locations.json?location=geo:33.848977,-84.373362&apikey=o3MaOGhwkmxtNIDM"]];
        //    _venue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", urlString);
        
        
        AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@", responseObject);
            
            
            
        } failure:nil];
        
        [operation start];

        
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1.0, 1.0));
        [mapView setRegion:region animated:YES];
        
        
    }
}

-(void) requestAlwaysAuthorization
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
