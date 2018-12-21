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
#import <AFNetworking/AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import "UICollectionViewCellPosts.h"
#import "DetailViewController.h"
#import "CollectionReusableHeader.h"
#import "YQL.h"
#import "DGActivityIndicatorView.h"
#import "BulletinPost.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "DA_Mobile-Swift.h"
#import <MaterialControls/MaterialControls.h>

@class BulletinData;

@interface BulletinViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewCellPostsDelegate, BulletinDataDelegate, MDButtonDelegate>

// properties
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *weather;
@property (strong, nonatomic) NSMutableArray *upcomingMeals;
@property (strong, nonatomic) NSMutableArray *birthdays;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *headerContent;
@property (strong, nonatomic) UIImage *weatherIcon;
@property (strong, nonatomic) NSString *weatherInfo;
@property (strong, nonatomic) NSMutableArray *weathers;
@property (strong, nonatomic) BulletinData *bulletinData;

@property (weak, nonatomic) IBOutlet MDButton *moreButton;
@property (weak, nonatomic) IBOutlet MDButton *feedbackButton;
@property (weak, nonatomic) IBOutlet MDButton *expandCollapseButton;
@property (weak, nonatomic) IBOutlet MDButton *filterButton;

@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *postsView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

// methods
- (IBAction)expandCollapse:(id)sender;
- (IBAction)filter:(id)sender;


@end

