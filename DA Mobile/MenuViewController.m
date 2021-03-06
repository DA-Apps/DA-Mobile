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

@property BOOL isLoading;

@end

@implementation MenuViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    
    self.isLoading = YES;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"MenuTableViewHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    NSURL *url = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData  * _Nonnull data, NSURLResponse * _Nonnull response, NSError *_Nonnull error) {
        TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseMenu:hpple];
                self.isLoading = NO;
                [self.tableView reloadData];
            });
        }
    }] resume];
}

-(void)viewDidAppear:(BOOL)animated{
    self.todaySelected = YES;
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectedTomorrow{
    self.todaySelected = NO;
    [self.tableView reloadData];
}

-(void)selectedToday{
    self.todaySelected = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.todayMeals.count == 0) {
        return self.view.frame.size.height - 250;
    }
    return 48;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (!self.todaySelected) {
        switch (section) {
            case 0:
                if (self.tomorrowMeals.firstObject.count == 0)
                    return nil;
                return @"Breakfast";
                break;
            case 1:
                if (self.tomorrowMeals.firstObject.count == 0)
                    return @"Brunch";
                    
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
    
    if (self.todaySelected) {
        return self.todayMeals.count + 1;
    }else{
        return self.tomorrowMeals[section].count + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isLoading) {
        EmptyNotifierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyNotifier" forIndexPath:indexPath];
        cell.icon.hidden = YES;
        cell.mainTitle.text = @"Loading...";
        cell.secondTitle.hidden = YES;
        int type = arc4random_uniform(4);
        switch (type) {
            case 0:
                cell.indicator.type = 20;
                break;
            case 1:
                cell.indicator.type = 31;
                break;
            case 2:
                cell.indicator.type = 29;
                break;
            case 3:
                cell.indicator.type = 18;
                break;
            default:
                break;
        }
        cell.indicator.tintColor = [UIColor darkGrayColor];
        [cell.indicator startAnimating];
        return cell;
    }
    if (self.todayMeals.count == 0 && self.isLoading == NO) {
        EmptyNotifierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyNotifier" forIndexPath:indexPath];
        cell.indicator.hidden = YES;
        [cell.indicator stopAnimating];
        cell.mainTitle.hidden = NO;
        cell.secondTitle.hidden = NO;
        cell.icon.hidden = NO;
        cell.icon.image = [UIImage imageNamed:@"icons8-food"];
        cell.mainTitle.text = @"No menu available";
        cell.secondTitle.text = @"Please check again later";
        return cell;
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        SegmentTableViewCell *cell = (SegmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"segmentCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableID" forIndexPath: indexPath];
        if (self.todaySelected)
            cell.textLabel.text = self.todayMeals[indexPath.row - 1];
        else{
            if (indexPath.row - 1 < 0)
                cell.textLabel.text = self.tomorrowMeals[indexPath.section][0];
            else
                cell.textLabel.text = self.tomorrowMeals[indexPath.section][indexPath.row - 1];
        }
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.todaySelected) {
        return 1;
    }else if (self.todayMeals.count == 0 && self.tomorrowMeals.count == 0){
        return 1;
    }else{
        return 3;
    }
}

#pragma mark - Private methods

-(void) parseMenu:(TFHpple *) data{
    
    self.todayMeals = [[NSMutableArray alloc] init];
    self.tomorrowMeals = [[NSMutableArray alloc] init];
    
    [self getTodayMeals:data];
    
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
                    mealType = @"DINNER";
                    break;
                default:
                    break;
            }
            [self.tomorrowMeals addObject:[self parseMenuHTML:[key stringByAppendingString:mealType] hppleData:data]];
        }
    }
}

-(void)getTodayMeals:(TFHpple *) data{
    
    self.todayMeals = [NSMutableArray array];
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
        if (hour < 12)
            mealType = @"BRUNCH";
        else
            mealType = @"DINNER";
    } else {
        if (hour < 9)
            mealType = @"BREAKFAST";
        else if (hour < 13)
            mealType = @"LUNCH";
        else
            mealType = @"DINNER";
    }
    if (hour >= 18) {
        mealType = @"BREAKFAST";
        currentTime = [NSDate dateWithTimeInterval:86400 sinceDate:currentTime];
        [formatter setDateFormat:@"yyyy-MM-dd-"];
        key = [formatter stringFromDate: currentTime];
    }
    key = [key stringByAppendingString:mealType];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [self.todayMeals addObject:element.content];
}

-(NSMutableArray *)parseMenuHTML:(NSString *)key hppleData:(TFHpple *)data{
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [array addObject:element.content];
    
    return array;
}

@end
