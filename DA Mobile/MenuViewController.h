//
//  MenuViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/7/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"
#import "SegmentTableViewCell.h"
#import "EmptyNotifierTableViewCell.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface MenuViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, SegmentTableViewCellDelegate>

@property BOOL todaySelected;
@property (strong, nonatomic) NSMutableArray *todayMeals;
@property (strong, nonatomic) NSMutableArray <NSMutableArray *> *tomorrowMeals;

@end
