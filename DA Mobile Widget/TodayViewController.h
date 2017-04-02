//
//  TodayViewController.h
//  DA Mobile Widget
//
//  Created by Yongyang Nie on 4/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) NSMutableArray *weathers;

@property (weak, nonatomic) IBOutlet UITableView *weatherTable;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet UIImageView *tempIcon;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@end
