//
//  MAViewController.h
//  WeatherForecasting
//
//  Created by apple on 03/07/14.
//  Copyright (c) 2014 redbytes. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import <GoogleMaps/GMSMapView.h>
//#import "MAAppContext.h"

@interface MAViewController : UIViewController <NSURLConnectionDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic, strong) NSString *cityString;
@property (nonatomic, strong) NSString *countryString;
@property (nonatomic, strong) CLLocation *userLocation;
@property (strong, nonatomic) IBOutlet UILabel *cityLbl;
@property (strong, nonatomic) IBOutlet UITextField *cityTxtFld;
@property (strong, nonatomic) IBOutlet UIButton *fetchBtn;
- (IBAction)fetchBtnTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *wifiTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *wifimessageLbl;

@property (nonatomic, strong) NSTimer *timer;

//@property (strong, nonatomic) IBOutlet UILabel *cityLbl;


@end
