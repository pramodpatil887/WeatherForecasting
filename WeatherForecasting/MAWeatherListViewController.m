//
//  MAWeatherListViewController.m
//  WeatherForecasting
//
//  Created by apple on 03/07/14.
//  Copyright (c) 2014 redbytes. All rights reserved.
//


#import "MAWeatherListViewController.h"
#import "MAWeatherForecastObj.h"
#import "MAWeatherInfoObj.h"
#import "MACustomTableCell.h"
#import "DejalActivityView.h"

@interface MAWeatherListViewController ()
{
    NSString *_cityNameStr;
    MAWeatherForecastObj *weatherForecaseObj;
    MAWeatherInfoObj *weatherInfoObj;
    NSMutableArray *weatherForeCastArray;
    NSString *_countryString;
}
@end

@implementation MAWeatherListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     weatherForeCastArray = [[NSMutableArray alloc] init];
    
    self.cityNameLbl.text = [NSString stringWithFormat:@"Welcome, %@, %@", _cityNameStr,_countryString];
    
    NSString *urlTemplate = @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=%@";
    NSString *cityNameStr = _cityNameStr;//self.cityTxtFld.text;
    NSString *appIDStr = AppId;
    NSString *stringUrl = [NSString stringWithFormat:urlTemplate, cityNameStr, appIDStr];
    
    [DejalActivityView activityViewForView:self.view withLabel:@"Fetching.." width:120];
    
    NSURL *urlasString = [NSURL URLWithString:stringUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlasString];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	// Do any additional setup after loading the view.
    
    self.title = @"WeatherForecasting";
}

// initializer for fetching the city and country.
-(id)initWithCity:(NSString *)cityName andcountry:(NSString *)countryName
{
    _cityNameStr = cityName;
    _countryString = countryName;
    return self;
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [DejalActivityView removeView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [DejalActivityView removeView];
    
    //NSLog(@"%@",_responseData);
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&myError];
    //NSLog(@"%@", res);
    if(myError)
    {
        
    }
    else
    {
        NSString *cityStr = [[res objectForKey:@"city"] objectForKey:@"name"];
        //NSLog(@"City Name %@", cityStr);
        NSString *countryStr = [[res objectForKey:@"city"] objectForKey:@"country"];
       // NSLog(@"Country Name %@", countryStr);
        NSArray *listArray = [res objectForKey:@"list"];
        NSDictionary *dict;
        for(dict in listArray)
            
        {
            weatherForecaseObj = [[MAWeatherForecastObj alloc] init];
            
            weatherForecaseObj.name = cityStr;
            weatherForecaseObj.countryStr = countryStr;
            
            NSString *cloudStr = [dict objectForKey:@"clouds"];
            weatherForecaseObj.cloudStr = cloudStr;
            NSString *degStr = [dict objectForKey:@"deg"];
            weatherForecaseObj.degStr = degStr;
            NSString *humidityStr = [dict objectForKey:@"humidity"];
            weatherForecaseObj.humidityStr = humidityStr;
            NSString *pressureStr = [dict objectForKey:@"pressure"];
            weatherForecaseObj.pressureStr = pressureStr;
            NSString *speedStr  = [dict objectForKey:@"speed"];
            weatherForecaseObj.speedStr = speedStr;
            NSString *dayStr     = [[dict objectForKey:@"temp"] objectForKey:@"day"];
            weatherForecaseObj.dayStr = dayStr;
            NSString *eveStr = [[dict objectForKey:@"temp"] objectForKey:@"eve"];
            weatherForecaseObj.eveStr = eveStr;
            NSString *mornStr = [[dict objectForKey:@"temp"] objectForKey:@"morn"];
            weatherForecaseObj.mornStr = mornStr;
            NSString *nightStr = [[dict objectForKey:@"temp"] objectForKey:@"night"];
            weatherForecaseObj.nightStr = nightStr;
            //NSString *noonStr = [[dict objectForKey:@"temp"] objectForKey:@"noon"];
            //weatherForecaseObj.noonStr = noonStr;
            NSArray *weatherArray = [dict objectForKey:@"weather"];
            //weatherForecaseObj.cloudStr = cloudStr;
            NSMutableArray *subCategoryObjList = [[NSMutableArray alloc] init];
            
            NSDictionary *weatherDict;
            for(weatherDict in weatherArray)
            {
                weatherInfoObj = [[MAWeatherInfoObj alloc] init];
                NSString *descriptionStr = [weatherDict objectForKey:@"description"];
                weatherInfoObj.weatherdescription = descriptionStr;
                //NSLog(@"%@", descriptionStr);
                NSString *mainStr = [weatherDict objectForKey:@"main"];
                weatherInfoObj.main = mainStr;
               // NSLog(@"%@", mainStr);
                [subCategoryObjList addObject:weatherInfoObj];
            }
            [weatherForecaseObj setWeatherArray:subCategoryObjList];
            [weatherForeCastArray addObject:weatherForecaseObj];
        }
        [self._TableView reloadData];
    }
}

#pragma mark UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weatherForeCastArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MACustomTableCell";
    MACustomTableCell  *cell = (MACustomTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MACustomTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    weatherForecaseObj = [weatherForeCastArray objectAtIndex:indexPath.row];
    NSLog(@"%@", [weatherForecaseObj degStr]);
    NSLog(@"%@", [[weatherForecaseObj weatherArray] valueForKey:@"description"]);
    
    NSDictionary *weatherDict;
    for(weatherDict in [weatherForecaseObj weatherArray])
    {
       cell.weatherDescLbl.text = [weatherDict valueForKey:@"weatherdescription"];
        [cell.numberLbl setTextColor:[UIColor colorWithRed:77/255.0f green:199/255.0f blue:54/255.0f alpha:1.0f]];
    }
    //double morng = weatherForecaseObj.mornStr;
    cell.morLbl.text = [NSString stringWithFormat:@"%@ f",weatherForecaseObj.mornStr];
    cell.noonLbl.text = [NSString stringWithFormat:@"%@ f",weatherForecaseObj.dayStr];
    cell.nightLbl.text = [NSString stringWithFormat:@"%@ f",weatherForecaseObj.nightStr];
    cell.eveLbl.text = [NSString stringWithFormat:@"%@ f",weatherForecaseObj.eveStr];
    cell.dayWLbl.text = [NSString stringWithFormat:@"%@ mph", weatherForecaseObj.speedStr];
    cell.humidityLbl.text = [NSString stringWithFormat:@"%@", weatherForecaseObj.humidityStr];
    NSInteger currentValue = indexPath.row + 1;
    cell.numberLbl.text = [NSString stringWithFormat:@"Day %ld", (long)currentValue];
    //[weatherForecaseObj.weatherArray valueForKey:@"description"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

#pragma mark UITableViewDataDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
