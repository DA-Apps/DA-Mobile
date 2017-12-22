//
//  TodayViewController.m
//  DA Mobile Widget
//
//  Created by Yongyang Nie on 4/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

#pragma mark - UITableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.menuTable])
        return @"upcoming meal";
    else
        return @"forecast";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 10, 22)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 10, 22)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    
    if ([tableView isEqual:self.weatherTable]) {
        NSString *string = @"forecast";
        [label setText:string];
        [view setBackgroundColor:[UIColor whiteColor]];
    }else{
        NSString *string = @"upcoming meal";
        [label setText:string];
        [view setBackgroundColor:[UIColor colorWithRed:38.0/255.0 green:137.0/255.0 blue:40.0/255.0 alpha:1.0]];
        label.textColor = [UIColor whiteColor];
    }
    
    [view addSubview:label];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.menuTable]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = [self.foods objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCellid" forIndexPath:indexPath];
        NSDictionary *dic = [self.weathers objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@ - %@", [dic objectForKey:@"low"], [dic objectForKey:@"high"]];
        cell.textLabel.text = [dic objectForKey:@"date"];
        cell.detailTextLabel.text = str;
        cell.imageView.image = [self imageWithImage:
                                [self getWeatherIcon:[dic objectForKey:@"text"]] scaledToSize:CGSizeMake(25, 25)];
        return cell;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.menuTable])
        return self.foods.count;
    else
        return self.weathers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - Private

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)getWeatherIcon:(NSString *)string{
    
    if ([string containsString:@"Sunny"] || [string containsString:@"Fair"]) {
        return [UIImage imageNamed:@"sunny"];
    }else if ([string containsString:@"Rainy"]){
        return [UIImage imageNamed:@"rainy"];
    }else if ([string containsString:@"Snow"]){
        return [UIImage imageNamed:@"snow"];
    }else if ([string containsString:@"Freezing"] || [string containsString:@"Sleet"]){
        return [UIImage imageNamed:@"sleet"];
    }else if ([string containsString:@"Windy"]){
        return [UIImage imageNamed:@"windy"];
    }else if ([string containsString:@"Cloudy"]){
        return [UIImage imageNamed:@"cloudy"];
    }else{
        return [UIImage imageNamed:@"unknown"];
    }
}

-(void)syncData{
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    self.foods = [defaults objectForKey:@"menuData"];
    self.weathers = [defaults objectForKey:@"weatherData"];
    [self.menuTable reloadData];
    [self.weatherTable reloadData];
    self.tempLabel.text = [[self.weathers lastObject] objectForKey:@"temp"];
    self.tempIcon.image = [self getWeatherIcon:[[self.weathers lastObject] objectForKey:@"text"]];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    self.menuWidth.constant = self.view.frame.size.width / 2 + 10;
    self.weatherWidth.constant = self.view.frame.size.width / 2 - 25;
    [self syncData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0.0, 300);
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

@end
