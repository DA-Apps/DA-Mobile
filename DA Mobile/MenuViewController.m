//
//  MenuViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/7/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "MenuViewController.h"
#import "TFHpple.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Begin downloading data");
    [self selectDate:nil];
    self.indicator.hidden = NO;
    self.indicator.tintColor = [UIColor grayColor];
    self.indicator.type = DGActivityIndicatorAnimationTypeThreeDots;
    [self.indicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData  * _Nonnull data, NSURLResponse * _Nonnull response, NSError *_Nonnull error) {
        TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                [self parseMenu:hpple];
                [self.tableView reloadData];
            });
        }
    }] resume];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectDate:(id)sender {
    if (self.segementedControl.selectedSegmentIndex == 0) {
        self.tableView.hidden = NO;
        self.tomorrowTable.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.tableView.hidden = YES;
        self.tomorrowTable.hidden = NO;
        [self.tomorrowTable reloadData];
    }
}

#pragma mark - UITableView delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.tomorrowTable]) {
        switch (section) {
            case 0:
                if (self.tomorrowMeals.firstObject.count == 0) {
                    return nil;
                }
                return @"Breakfast";
                break;
            case 1:
                if (self.tomorrowMeals.firstObject.count == 0) {
                    return @"Brunch";
                }
                return @"Lunch";
                break;
            case 2:
                return @"Dinner";
                break;
                
            default:
                break;
        }
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView]) {
        return self.upcomingMeals.count;
    }else{
        return self.tomorrowMeals[section].count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableID" forIndexPath: indexPath];
    if ([tableView isEqual:self.tableView]) {
        cell.textLabel.text = self.upcomingMeals[indexPath.row];
    }else{
        cell.textLabel.text = self.tomorrowMeals[indexPath.section][indexPath.row];
    }
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.tableView]) {
        return 1;
    }else{
        return 3;
    }
}

#pragma mark - Private methods

-(void) parseMenu:(TFHpple *) data{
    
    self.upcomingMeals = [[NSMutableArray alloc] init];
    self.tomorrowMeals = [[NSMutableArray alloc] init];
    
    [self getUpcomingMeals:data];
    
    NSDate *currentTime = [NSDate dateWithTimeInterval:86400*2 sinceDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-"];
    NSString *key = [formatter stringFromDate: currentTime];
    
    [formatter setDateFormat: @"EE"];
    NSString *day = [formatter stringFromDate: currentTime];
    NSString *mealType;
    
    if([day isEqualToString: @"Sun"]) {
        [self.tomorrowMeals addObject:[NSMutableArray array]];
        [self.tomorrowMeals addObject:[self parseMenuHTML:[key stringByAppendingString:@"BRUNCH"] hppleData:data]];
        [self.tomorrowMeals addObject:[self parseMenuHTML:[key stringByAppendingString:@"DINNER"] hppleData:data]];
    } else {
        for (int x = 0; x < 3; x++) {
            switch (x) {
                case 0:
                    mealType = @"BREAKFAST";
                    break;
                case 1:
                    mealType = @"LUNCH";
                    break;
                case 2:
                    mealType = @"BREAKFAST";
                    break;
                default:
                    break;
            }
            [self.tomorrowMeals addObject:[self parseMenuHTML:[key stringByAppendingString:mealType] hppleData:data]];
        }
    }
}

-(void) getUpcomingMeals:(TFHpple *) data{
    
    self.upcomingMeals = [NSMutableArray array];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-"];
    NSString *key = [formatter stringFromDate: currentTime];
    
    [formatter setDateFormat: @"EE"];
    NSString *day = [formatter stringFromDate: currentTime];
    
    [formatter setDateFormat: @"HH"];
    int hour = [[formatter stringFromDate: currentTime] intValue];
    NSString *mealType;
    
    if([day isEqualToString: @"Sun"]) {
        if (hour < 12) mealType = @"BRUNCH";
        else mealType = @"DINNER";
    } else {
        if (hour < 9)
            mealType = @"BREAKFAST";
        else if (hour < 13) mealType = @"LUNCH";
        else mealType = @"DINNER";
    }
    if (hour > 18) {
        mealType = @"BREAKFAST";
        currentTime = [NSDate dateWithTimeInterval:86400 sinceDate:currentTime];
        [formatter setDateFormat:@"yyyy-MM-dd-"];
        key = [formatter stringFromDate: currentTime];
    }
    key = [key stringByAppendingString:mealType];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [self.upcomingMeals addObject:element.content];
}

-(NSMutableArray *)parseMenuHTML:(NSString *)key hppleData:(TFHpple *)data{
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [array addObject:element.content];
    
    return array;
}

@end
