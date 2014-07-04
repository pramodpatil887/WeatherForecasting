//
//  MACustomTableCell.h
//  WeatherForecasting
//
//  Created by apple on 03/07/14.
//  Copyright (c) 2014 redbytes. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MACustomTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weatherDescLbl;
@property (strong, nonatomic) IBOutlet UILabel *eveLbl;
@property (strong, nonatomic) IBOutlet UILabel *noonLbl;
@property (strong, nonatomic) IBOutlet UILabel *nightLbl;
@property (strong, nonatomic) IBOutlet UILabel *morLbl;
@property (strong, nonatomic) IBOutlet UILabel *dayWLbl;
@property (strong, nonatomic) IBOutlet UILabel *humidityLbl;
@property (strong, nonatomic) IBOutlet UILabel *numberLbl;

@end
