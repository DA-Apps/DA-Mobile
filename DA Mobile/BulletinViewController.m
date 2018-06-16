//
//  ViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "BulletinViewController.h"
#import "TFHpple.h"

@interface BulletinViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property BOOL _panBegin;
@property BOOL _isExpanded;

@end

@implementation BulletinViewController


# pragma mark - Bulletin Data Delegate

- (void)bulletinDataLoadingErrorWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps, Sorry..." message:@"We couldn't retrieve data. Please quit the app and try again later" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)finishLoadingData {
    [self.postsView reloadData];
}


# pragma mark - CollectionHeaderDelegate

-(void)expandMenu{
    
    int heightAnimation = 0;
    
    if (self.headerContent.firstObject.count == 0) {
        [self.headerContent replaceObjectAtIndex:0 withObject:self.upcomingMeals];
        heightAnimation = 150;
    }else{
        [self.headerContent replaceObjectAtIndex:0 withObject:[NSMutableArray array]];
        heightAnimation = -150;
    }
    CollectionReusableHeader *header = (CollectionReusableHeader *)[self.postsView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [header.table reloadData];
    
    [self.postsView performBatchUpdates:nil completion:nil];
}

#pragma mark - Location Manager

-(CLLocationCoordinate2D) getLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bulletinData.bulletinData[indexPath.section].posts.count == 0) //check if no post in one day
        return CGSizeMake(self.view.frame.size.width - 16, 100);
    if (self._isExpanded) {
        return CGSizeMake(self.view.frame.size.width - 16, 270);
    }else{
        return CGSizeMake(self.view.frame.size.width - 16, 100);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSInteger viewWidth = self.view.frame.size.width;
    NSInteger totalCellWidth = self.view.frame.size.width - 16 * 1;
    NSInteger totalSpacingWidth = 0;
    
    NSInteger leftInset = (viewWidth - (totalCellWidth + totalSpacingWidth)) / 2;
    NSInteger rightInset = leftInset;
    
    return UIEdgeInsetsMake(12, leftInset, 18, rightInset);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPost" forIndexPath:indexPath];
    DailyBulletinData *day = self.bulletinData.bulletinData[indexPath.section];
    
    //check if no post in one day
    if (day.posts.count == 0)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellNoPost" forIndexPath:indexPath];
    else{
        
        cell.backgroundColor = [UIColor clearColor];
        cell.title.text = day.posts[indexPath.row].title;
        if (day.posts[indexPath.row].imageLink.length > 8)
            [cell.image sd_setImageWithURL:[NSURL URLWithString:day.posts[indexPath.row].imageLink] placeholderImage:[UIImage imageNamed:@"ph_0.jpg"]];
        else
            cell.image.image = [UIImage imageNamed:day.posts[indexPath.row].imageLink];
        
        // animation
        UIBezierPath *bgMaskPath;
        
        if (!self._isExpanded){
            
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:5.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.imageRightBound.constant = cell.frame.size.width - 100;
                cell.titleHeight.constant = 100;
                cell.titleLeftBound.constant = 108;
                cell.titleBgLeftBound.constant = 100;
                [cell layoutIfNeeded];
            } completion:nil];
            
            bgMaskPath = [UIBezierPath bezierPathWithRoundedRect:cell.blurEffectView.bounds byRoundingCorners: UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
            
            cell.image.layer.cornerRadius = 0;
            UIBezierPath *imageMaskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
            // setting corner for cell blur background
            CAShapeLayer *imageMaskLayer = [CAShapeLayer layer];
            imageMaskLayer.frame = cell.image.bounds;
            imageMaskLayer.path = imageMaskPath.CGPath;
            cell.image.layer.mask = imageMaskLayer;
            
        }else{
            
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:5.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.imageRightBound.constant = 0;
                cell.titleHeight.constant = 79;
                cell.titleLeftBound.constant = 8;
                cell.titleBgLeftBound.constant = 0;
                [cell layoutIfNeeded];
            } completion:nil];
            
            bgMaskPath = [UIBezierPath bezierPathWithRoundedRect:cell.blurEffectView.bounds byRoundingCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
            UIBezierPath *imageMaskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, cell.frame.size.width, 270)];
            
            CAShapeLayer *imageMaskLayer = [CAShapeLayer layer];
            imageMaskLayer.frame = cell.image.bounds;
            imageMaskLayer.path = imageMaskPath.CGPath;
            cell.image.layer.mask = imageMaskLayer;
            cell.image.layer.cornerRadius = 15.0;
            cell.image.layer.masksToBounds = YES;
        }
        
        // setting corner for cell blur background
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.blurEffectView.bounds;
        maskLayer.path = bgMaskPath.CGPath;
        cell.blurEffectView.layer.mask = maskLayer;
        
        cell.delegate = self;
        cell.canSwipe = YES;
    }
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(10, 15);
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.25;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSUInteger count = self.bulletinData.bulletinData[section].posts.count;
    if (count == 0)
        return 1;
    else
        return count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.bulletinData.bulletinData.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (self.headerContent.firstObject.count == 0 && self.headerContent.lastObject.count == 0 && section == 0)
        // first header, collaspsed, second largest
        return CGSizeMake(self.postsView.frame.size.width, 150);
    else if (section != 0)
        // small header
        return CGSizeMake(self.postsView.frame.size.width, 115);
    else
        // large header, expanded
        return CGSizeMake(self.postsView.frame.size.width, 250);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CollectionReusableHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.dateLabel.text = self.bulletinData.bulletinData[indexPath.section].dateString;
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
        headerView.tempLabel.hidden = NO;
        headerView.weatherIcon.hidden = NO;
        headerView.table.hidden = NO;
        headerView.tempLabel.text = self.weatherInfo;
        headerView.weatherIcon.image = self.weatherIcon;
        headerView.array = [NSMutableArray array];
        headerView.array = self.headerContent;
        [headerView.table reloadData];
        headerView.delegate = self;
    }else if (kind == UICollectionElementKindSectionHeader && indexPath.section != 0){
        headerView.tempLabel.hidden = YES;
        headerView.weatherIcon.hidden = YES;
        headerView.table.hidden = YES;
    }
    
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDetails" sender:nil];
    });
}

#pragma mark - Private

-(void)saveToBookMark:(UICollectionViewCellPosts *)cell{
    
    NSIndexPath *index = [self.postsView indexPathForCell:cell];
    Post *post = self.bulletinData.bulletinData[index.section].posts[index.row];
    [self savePosts:post.title withContent:post.content withImage:post.imageLink withLink:post.link];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post Saved" message:@"You have bookmarked this post" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSMutableArray *)queryWeatherAPI{
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    YQL *yql = [[YQL alloc] init];
    
    NSString *woeidQuery = [NSString stringWithFormat:@"SELECT woeid FROM geo.places WHERE text=\"(%f,%f)\"", coordinate.latitude, coordinate.longitude];
    NSDictionary *woeidResults = [yql query:woeidQuery];
    if (![[[woeidResults objectForKey:@"query"] objectForKey:@"count"]  isEqual:@0]) {
        NSString *woeid = [[[[woeidResults objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"place"] objectForKey:@"woeid"];
        NSString *queryString = [NSString stringWithFormat:@"select * from weather.forecast where woeid in (%@)", woeid];
        
        NSDictionary *results = [yql query:queryString];
        if ([[[results objectForKey:@"query"] objectForKey:@"count"] intValue] == 0) {
            return nil;
            
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:results[@"query"][@"results"][@"channel"][@"item"][@"forecast"]];
            NSDictionary *dic = results[@"query"][@"results"][@"channel"][@"item"][@"condition"];
            [array addObject:dic];
            return array;
        }
    }
    return nil;
}

-(void)getForcast{
    
    self.weathers = [self queryWeatherAPI];
    self.weather = [self.weathers lastObject];
    int i = arc4random()%3;
    if (self.weathers) {
        self.weatherInfo = [self.weather objectForKey:@"temp"];
        self.weatherIcon = [self setWeatherImage:[self.weather objectForKey:@"text"]];
        [self.postsView reloadData];
        [self syncExtension];
    }else if (i == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps" message:@"We couldn't get the weather data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getForcast];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)syncExtension{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    
    [sharedDefaults setObject:self.upcomingMeals forKey:@"menuData"];
    [sharedDefaults setObject:self.weathers forKey:@"weatherData"];
    [sharedDefaults synchronize];
    NSLog(@"synced with extension");
}

-(void)setShadowforView:(UIView *)view{
    
    // drop shadow
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.6];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(5.0, 2.0)];
}

-(void)cacheData:(NSMutableArray <NSDictionary *> *)posts menu:(NSMutableArray *)nextMeal{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    [sharedDefaults setObject:posts forKey:@"posts"];
    [sharedDefaults setObject:nextMeal forKey:@"nextMeal"];
    [sharedDefaults synchronize];
}

-(void)loadCachedData{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    // self.posts = [sharedDefaults objectForKey:@"posts"];
    self.upcomingMeals = [sharedDefaults objectForKey:@"nextMeal"];
    [sharedDefaults synchronize];
}

-(UIImage *) setWeatherImage:(NSString*) weatherType {
    
    if ([weatherType containsString:@"Cloudy"])
        return [UIImage imageNamed:@"cloudy"];
    else if ([weatherType containsString:@"Rainy"] || [weatherType containsString:@"Showers"])
        return [UIImage imageNamed:@"rainy"];
    else if ([weatherType containsString:@"Sunny"])
        return [UIImage imageNamed:@"sunny"];
    else if ([weatherType containsString:@"Snow"])
        return [UIImage imageNamed:@"snow"];
    else if ([weatherType containsString:@"Fair"])
        return [UIImage imageNamed:@"snow"];
    else if ([weatherType containsString:@"Sleet"])
        return [UIImage imageNamed:@"sleet"];
    else if ([weatherType containsString:@"Thunder"])
        return [UIImage imageNamed:@"thunder"];
    else if ([weatherType containsString:@"Windy"])
        return [UIImage imageNamed:@"windy"];
    else
        return [UIImage imageNamed:@"unknown"];
}

-(void) parseMenu:(TFHpple *) data{
    
    self.upcomingMeals = [NSMutableArray array];
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
        currentTime = [NSDate dateWithTimeInterval:72000 sinceDate:currentTime];
        [formatter setDateFormat:@"yyyy-MM-dd-"];
        key = [formatter stringFromDate: currentTime];
    }
    key = [key stringByAppendingString:mealType];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [self.upcomingMeals addObject:element.content];
}

-(void)startRefresh:(UIRefreshControl *)refresh{
    
    if (self.bulletinData.bulletinData.count == 0) {
        self.activityIndicator.hidden = NO;
        self.activityIndicator.tintColor = [UIColor grayColor];
        self.activityIndicator.type = DGActivityIndicatorAnimationTypeThreeDots;
        [self.activityIndicator startAnimating];
    }
    
# warning implementation needed
    
    
}

- (void)savePosts:(NSString *)title withContent: (NSString *)content withImage:(NSString *)image withLink:(NSString *)url{
    
    BulletinPost *post = [[BulletinPost alloc] init];
    post.title = title;
    post.content = content;
    post.image = image;
    post.postURL = url;
    
    if (![self contains:title]){
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:post];
        }];
    }
}

-(BOOL)contains:(NSString *)title {
    for (BulletinPost *post in [BulletinPost allObjects]){
        if ([post.title isEqualToString:title])
            return YES;
    }
    return NO;
}

- (IBAction)expandCollapse:(id)sender {
    
    self._isExpanded = !self._isExpanded;
    if (self._isExpanded)
        [self.expandCollapseButton setImage:[UIImage imageNamed:@"collapse"]];
    else
        [self.expandCollapseButton setImage:[UIImage imageNamed:@"expand"]];
    
    [self.postsView reloadData];
}

- (IBAction)filter:(id)sender {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [segue destinationViewController];
        DetailViewController *vc = (DetailViewController *)[nav topViewController];
        NSIndexPath *indexPath = self.postsView.indexPathsForSelectedItems.firstObject;
        Post *post = self.bulletinData.bulletinData[indexPath.section].posts[indexPath.row];
        
        vc.postURL = post.link;
        vc.contentString = post.content;
        vc.contentImage = post.imageLink;
        vc.titleString = post.title;
    }
}


#pragma mark - Gesture Recognizer

-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint location = [pan locationInView:self.postsView];
    NSIndexPath *indexPath = [self.postsView indexPathForItemAtPoint:location];
    UICollectionViewCellPosts *cell = (UICollectionViewCellPosts *)[self.postsView cellForItemAtIndexPath:indexPath];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [cell beginPanAccessoryView:location];
        cell.canSwipe = YES;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        if (cell.menuOpened == YES) {
            [cell panAccessoryViewRight:location];
        }else{
            [cell panAccessoryViewLeft:location];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled){
        [cell endPanAccessoryView:location];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if (gestureRecognizer == self.pan && otherGestureRecognizer == self.postsView.panGestureRecognizer) {
        return NO;
    }
    return NO;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    //look at gesture recognizer
    NSLog(@"%@", gestureRecognizer);
    if ([gestureRecognizer isEqual:self.pan]) {
        CGPoint vel = [self.pan velocityInView:self.postsView];
        if (fabs(vel.x) != 0 && fabs(vel.y) < fabs(vel.x))
            return YES;
        else
            return NO;
    }
    return NO;
}

#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    //just a reminder, also call viewDidLoad before all the setup.
    
    [super viewDidLoad];
    
    // setup drop down menu
    
    self.dropdownMenu.layer.borderColor = [[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] CGColor];
    self.dropdownMenu.layer.borderWidth = 0.5;
    
    UIColor *selectedBackgroundColor = [UIColor colorWithRed:0.91 green:0.92 blue:0.94 alpha:1.0];
    self.dropdownMenu.selectedComponentBackgroundColor = selectedBackgroundColor;
    self.dropdownMenu.dropdownBackgroundColor = selectedBackgroundColor;
    
    self.dropdownMenu.dropdownShowsTopRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBorder = YES;
    
    self.dropdownMenu.backgroundDimmingOpacity = 0.05;
    
    // -----
    
    self._isExpanded = YES;
    
    self.bulletinData = [[BulletinData alloc] initWithPostDayCount:5];
    [self.bulletinData retrieveHTMLData];
    self.bulletinData.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    
    self.headerContent = [NSMutableArray array];
    [self.headerContent addObject:[NSMutableArray array]];
    [self.headerContent addObject:[NSMutableArray array]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.postsView addSubview:refreshControl];
    self.postsView.alwaysBounceVertical = YES;
    
    [self loadCachedData];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined | [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied | [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        [self.locationManager requestWhenInUseAuthorization];
    else
        [self getForcast];
    
    //[self startRefresh:nil];
    self.feedbackButton.layer.cornerRadius = 3.0f;
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.pan.delegate = self;
    [self.postsView addGestureRecognizer:self.pan];
    
}


@end
