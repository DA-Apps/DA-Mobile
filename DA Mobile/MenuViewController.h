//
//  MenuViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/7/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segementedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tomorrowTable;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *noMealIcon;
@property (weak, nonatomic) IBOutlet UILabel *noMealLabel;
@property (strong, nonatomic) NSMutableArray *todayMeals;
@property (strong, nonatomic) NSMutableArray <NSMutableArray *> *tomorrowMeals;

@end
