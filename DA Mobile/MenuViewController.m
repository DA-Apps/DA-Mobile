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
    self.tableView.alpha = 0;
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
                [UIView animateWithDuration:0.2 animations:^{
                    self.tableView.alpha = 1.0f;
                }];
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
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.meals objectAtIndex:self.segementedControl.selectedSegmentIndex].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableID" forIndexPath: indexPath];
    cell.textLabel.text = [[self.meals objectAtIndex:self.segementedControl.selectedSegmentIndex] objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void) parseMenu:(TFHpple *) data{
    
    self.meals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++)
    {
        NSMutableArray *meal = [NSMutableArray array];
        
        NSDate *currentTime = [NSDate dateWithTimeInterval:86400*i sinceDate:[NSDate date]];
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
            [meal addObject:element.content];
        
        NSLog(@"%@", meal);
        [self.meals addObject:meal];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
