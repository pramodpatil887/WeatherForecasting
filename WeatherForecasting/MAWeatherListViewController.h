//
//  MAWeatherListViewController.h
//  WeatherForecasting
//
//  Created by apple on 03/07/14.
//  Copyright (c) 2014 redbytes. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MAWeatherListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *cityNameLbl;
@property (strong, nonatomic) IBOutlet UITableView *_TableView;
-(id)initWithCity:(NSString *)cityName andcountry:(NSString *)countryName;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end
