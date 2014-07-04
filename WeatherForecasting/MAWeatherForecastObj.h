//
//  MAWeatherForecastObj.h
//  WeatherForecasting
//
//  Created by Rameez on 4/29/14.
//  Copyright (c) 2014 Manjiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAWeatherForecastObj : NSObject
{
    NSString *cloudStr, *degStr, *humidityStr, *pressureStr, *speedStr, *dayStr, *eveStr, *mornStr, *nightStr ,*name, *countryStr, *noonStr;
}
@property (nonatomic, strong) NSString *cloudStr, *degStr, *humidityStr, *pressureStr, *speedStr, *dayStr, *eveStr, *mornStr, *nightStr, *name, *countryStr, *noonStr;
@property (nonatomic, strong) NSMutableArray *weatherArray;
@end
