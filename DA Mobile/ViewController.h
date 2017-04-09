//
//  ViewController.h
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <CoreLocation/CoreLocation.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "CollectionReusableHeader.h"
#import "CollectionViewFlowLayout.h"
#import "YQL.h"
#import "DGActivityIndicatorView.h"
#import "BulletinPost.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, CollectionReusableHeaderDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray <NSMutableArray *> *posts;
@property (strong, nonatomic) NSDictionary *weather;
@property (strong, nonatomic) NSMutableArray *upcomingMeals;
@property (strong, nonatomic) NSMutableArray *birthdays;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *headerContent;

@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *postsView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

