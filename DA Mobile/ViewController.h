//
//  ViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import <Realm/Realm.h>
#import <CoreLocation/CoreLocation.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "CollectionReusableHeader.h"
#import "CollectionViewFlowLayout.h"
#import "YQL.h"
#import "DGActivityIndicatorView.h"
#import "BulletinPost.h"
=======

#import <CoreLocation/CoreLocation.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "YQL.h"
#import <DGActivityIndicatorView.h>
>>>>>>> master

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, CollectionReusableHeaderDelegate, UICollectionViewCellPostsDelegate>

<<<<<<< HEAD
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *posts;
@property (strong, nonatomic) NSDictionary *weather;
@property (strong, nonatomic) NSMutableArray *upcomingMeals;
@property (strong, nonatomic) NSMutableArray *birthdays;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *headerContent;

@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;
=======
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) NSMutableArray *timeStamp;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray <UIImage *>*images;

@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITableView *weatherTable;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
>>>>>>> master
@property (weak, nonatomic) IBOutlet UICollectionView *postsView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

