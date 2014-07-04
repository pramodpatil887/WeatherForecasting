//
//  MAViewController.m
//  WeatherForecasting
//
//  Created by apple on 03/07/14.
//  Copyright (c) 2014 redbytes. All rights reserved.
//

#define currentLocationTag 121

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#import "MAViewController.h"
#import "MAWeatherForecastObj.h"
#import "MAWeatherListViewController.h"
#import "DejalActivityView.h"
#import "MTReachabilityManager.h"
#import "Reachability.h"

@interface MAViewController ()
{
    MAWeatherForecastObj *weatherForecaseObj;
    NSMutableArray *weatherForeCastArray;
}
@end

@implementation MAViewController

-(void)viewWillAppear:(BOOL)animated
{
    //Notification To identify whether Internet Connection is available or not.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

#pragma mark -
#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable])
    {
        self.wifimessageLbl.hidden = YES;
        self.wifiTitleLbl.hidden = YES;
    }
    else
    {
        self.wifimessageLbl.hidden = NO;
        self.wifiTitleLbl.hidden = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
self.title = @"WeatherForecasting";
    [self start12]; // Fetching the Current Location
    self.wifimessageLbl.hidden = YES;
    self.wifiTitleLbl.hidden = YES;
    UIColor* mainColor = [UIColor colorWithRed:201/255.0f green:223/255.0f blue:228/255.0f alpha:1.0f];
    [self.view setBackgroundColor:mainColor];
    self.cityLbl.hidden = YES;
    UIColor * registerColor = [UIColor colorWithRed:77/255.0f green:199/255.0f blue:54/255.0f alpha:1.0f];
    [self.fetchBtn setBackgroundColor:registerColor];
    [self.fetchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.cityTxtFld.leftViewMode = UITextFieldViewModeAlways;
    //[self.firstNameTxtFd addTarget:self action:@selector(textFieldDidChange)forControlEvents:UIControlEventEditingChanged];
    self.cityTxtFld.leftView = leftView;
    
    weatherForeCastArray = [[NSMutableArray alloc] init];
    
    // Alert View to confirm from user that he require Current Location or not.
    UIAlertView *currentLocation_Alert = [[UIAlertView alloc] initWithTitle:@"Do you want to fetch weatherforecast for current location" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [currentLocation_Alert show];
    currentLocation_Alert.tag = currentLocationTag;
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchBtnTouched:(id)sender
{
    if([self isValid])
    {
         self.cityLbl.hidden = YES;
        
        [MTReachabilityManager sharedManager];
        Reachability * networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            self.wifimessageLbl.hidden = NO;
            self.wifiTitleLbl.hidden = NO;
        }
        else
        {
            self.wifimessageLbl.hidden = YES;
            self.wifiTitleLbl.hidden = YES;
            
            self.cityTxtFld.layer.borderColor = [[UIColor clearColor] CGColor];
            self.cityTxtFld.layer.borderWidth = 1.0;
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MAWeatherListViewController *weatherListVC = [main instantiateViewControllerWithIdentifier:@"MAWeatherListViewController"];
            [self.navigationController pushViewController:[weatherListVC initWithCity:self.cityTxtFld.text andcountry:self.countryString] animated:YES];
        }
    }
    else
    {
        self.cityLbl.hidden = NO;
        self.cityTxtFld.layer.borderColor = [[UIColor redColor] CGColor];
        self.cityTxtFld.layer.borderWidth = 1.0;
    }
}

// Validation
-(BOOL)isValid
{
    if([self.cityTxtFld.text length] > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return YES;
}

-(void)start12
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

-(void)getPlaceDetails
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false&key=AIzaSyDqHMKBk57N6ytwJO0lz_PaFfUvQQIYcKo",_userLocation.coordinate.latitude,_userLocation.coordinate.longitude];
    
    NSString* webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:webStringURL];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        url1];
        [self performSelectorOnMainThread:@selector(fetchedAddress:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedAddress:(NSData *)responseData
{
    NSError* error;
    self.cityString = @"";
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSLog(@"Response : %@",json);
    NSString *str = [json objectForKey:@"status"];
    
    NSLog(@"Response : %@",json);
    if(json!= nil && ![json  isEqual: @""] && json != NULL && ![str isEqualToString:@"ZERO_RESULTS"])
    {
        NSArray * _placeItems = [[[json objectForKey:@"results"]objectAtIndex:0]objectForKey:@"address_components"] ;
        NSLog(@"Items : %@",_placeItems);
        
        for (int i=0; i<[_placeItems count]; i++)
        {
            NSDictionary *placeinfo = [_placeItems objectAtIndex:i];
            if([[placeinfo objectForKey:@"types"] containsObject:@"locality"])
            {
                NSLog(@"Items %d : %@",i,[placeinfo objectForKey:@"long_name"]);
                self.cityString = [placeinfo objectForKey:@"long_name"];
            }
            if([[placeinfo objectForKey:@"types"] containsObject:@"country"])
            {
                NSLog(@"country : %@",[placeinfo objectForKey:@"long_name"]);
                self.countryString = [placeinfo objectForKey:@"long_name"];
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    _userLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    
    [self getPlaceDetails];
    
    /*NSLog(@"lat%f - lon%f", _userLocation.coordinate.latitude, _userLocation.coordinate.longitude);
     //currentLocation = [[CLLocation alloc] initWithLatitude:41.893039 longitude:12.482604];
     [locationManager stopUpdatingLocation];
     NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
     CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
     [geocoder reverseGeocodeLocation:currentLocation
     completionHandler:^(NSArray *placemarks, NSError *error)
     {
     if (error)
     {
     NSLog(@"Geocode failed with error: %@", error);
     return;
     }
     if(placemarks.count > 0)
     {
     NSString *name = @"";
     NSString *zip = @"";
     self.cityString = @"";
     self.countryString =@"";
     self.AddressString = @"";
     CLPlacemark *placemark = [placemarks objectAtIndex:0];
     
     NSDictionary *addressDictionary = [placemark addressDictionary];
     NSLog(@"Sate %@",[addressDictionary objectForKey:@"State"]);
     NSLog(@"Street %@",[addressDictionary objectForKey:@"Street"]);
     NSLog(@"Country %@",[addressDictionary objectForKey:@"Country"]);
     NSLog(@"Name %@",[addressDictionary objectForKey:@"Name"]);
     NSLog(@"Thoroughfare %@",[addressDictionary objectForKey:@"Thoroughfare"]);
     
     NSLog(@"addressDictionary =%@",addressDictionary);
     NSLog(@"placemark.ISOcountryCode =%@",placemark.ISOcountryCode);
     NSLog(@"placemark.country =%@",placemark.country);
     NSLog(@"placemark.postalCode =%@",placemark.postalCode);
     NSLog(@"placemark.administrativeArea =%@",placemark.administrativeArea);
     NSLog(@"placemark.locality =%@",placemark.locality);
     NSLog(@"placemark.subLocality =%@",placemark.subLocality);
     NSLog(@"placemark.subThoroughfare =%@",placemark.subThoroughfare);
     
     if([addressDictionary objectForKey:@"Country"])
     {
     self.countryString = [addressDictionary objectForKey:@"Country"];
     NSLog(@"country : %@",self.countryString);
     }
     name = [addressDictionary objectForKey:@"Name"];
     zip = [addressDictionary objectForKey:@"ZIP"];
     if(name && zip && ![name isEqualToString:zip])
     {
     self.AddressString = [NSString stringWithFormat:@"%@,%@",name,zip];
     NSLog(@"AddressString : %@",self.AddressString);
     }
     else if (name)
     {
     self.AddressString = [NSString stringWithFormat:@"%@",name];
     NSLog(@"AddressString123 : %@",self.AddressString);
     }
     self.cityString = placemark.locality;
     NSLog(@"cityString : %@",self.cityString);
     }
     }];*/
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Reached loc mngr delegate method 2...error occurred");
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to Fetch Current Location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == currentLocationTag && buttonIndex == 1)
    {
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(fectchCurrentLocation:) userInfo:nil repeats:NO];
        [DejalActivityView activityViewForView:self.view withLabel:@"Fetching Current Location.." width:220];
    }
}

-(void)fectchCurrentLocation:(NSTimer *)timer
{
    [DejalActivityView removeView];
    self.cityTxtFld.text = self.cityString;
}

@end