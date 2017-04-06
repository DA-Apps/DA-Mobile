//
//  ViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "CollectionReusableHeader.h"
#import "YQL.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *timeStamp;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray <UIImage *>*images;
@property (strong, nonatomic) NSDictionary *weather;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITableView *weatherTable;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UICollectionView *postsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

