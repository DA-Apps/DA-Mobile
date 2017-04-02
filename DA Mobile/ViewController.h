//
//  ViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQL.h"
#import <CoreLocation/CoreLocation.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) NSMutableArray *timeStamp;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *titles;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITableView *weatherTable;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UICollectionView *postsView;
@property (weak, nonatomic) IBOutlet UIImageView *postsBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@end

