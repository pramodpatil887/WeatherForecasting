//
//  MAWeatherInfoObj.h
//  WeatherForecasting
//
//  Created by Rameez on 4/29/14.
//  Copyright (c) 2014 Manjiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAWeatherInfoObj : NSObject
{
    NSString *main, *weatherdescription;
}
@property (nonatomic, strong) NSString *main, *weatherdescription;
@end
