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

@property(nonatomic) CGPoint startPoint;
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
    [self parseMenu:self.bulletinData.htmlData];
    [self.postsView reloadData];
}

- (void)finishLoadingDataWithRefresh:(UIRefreshControl *)refresh{
    [refresh endRefreshing];
    [self parseMenu:self.bulletinData.htmlData];
    [self.postsView reloadData];
}

# pragma mark - CollectionHeader Delegate

-(void)expandMenu{
    
    int heightAnimation = 0;
    
    if (self.headerContent.firstObject.count == 0) {
        [self.headerContent replaceObjectAtIndex:0 withObject:self.upcomingMeals];
        heightAnimation = 150;
    }else{
        [self.headerContent replaceObjectAtIndex:0 withObject:[NSMutableArray array]];
        heightAnimation = -150;
    }
    // get header from collectionView
    CollectionReusableHeader *header = (CollectionReusableHeader *)[self.postsView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [header.table reloadData];
    
    [self.postsView performBatchUpdates:nil completion:nil];
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bulletinData.bulletinData[indexPath.section].posts.count == 0) //check if no post in one day
        return CGSizeMake(self.view.frame.size.width - 16, 100);
    if (self._isExpanded) {
        return CGSizeMake(self.view.frame.size.width - 16, 320);
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
        
        // display the post for this day
        cell.backgroundColor = [UIColor clearColor];
        cell.title.text = day.posts[indexPath.row].title;
        
        if (day.posts[indexPath.row].type == PostTypeStudentNews)
            cell.typeLabel.text = @"STUDENT NEWS";
        else if (day.posts[indexPath.row].type == PostTypeAthletics)
            cell.typeLabel.text = @"ATHLETICS";
        else if (day.posts[indexPath.row].type == PostTypeLostFound)
            cell.typeLabel.text = @"LOST & FOUND";
        else
            cell.typeLabel.text = @"NEWS";
        
        // has a url (web) image
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
            
            int titleHeight = 0;
            if (cell.title.text.length <= 35){
                titleHeight = 70;
            }else{
                titleHeight = 95;
            }
            
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:5.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.imageRightBound.constant = 0;
                cell.titleHeight.constant = titleHeight;
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
    cell.layer.shadowOpacity = 0.15;
    
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
        return CGSizeMake(self.postsView.frame.size.width, 110);
    else
        // large header, expanded
        return CGSizeMake(self.postsView.frame.size.width, 250);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CollectionReusableHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.dateLabel.text = self.bulletinData.bulletinData[indexPath.section].dateString;
    headerView.todayDateLabel.text = [self getDateText:headerView.dateLabel.text];
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
        headerView.todayDateLabel.hidden = NO;
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
        headerView.todayDateLabel.hidden = YES;
    }
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDetails" sender:nil];
    });
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

#pragma mark - Private Methods

-(NSString *)getDateText:(NSString *)dateDescription{
    
    NSDate *date = [NSDate date];
    if (![dateDescription isEqualToString:@"Today"]) {
        date = [date dateByAddingTimeInterval: -86400.0];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM dd"];
    return [formatter stringFromDate:date];
}

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
    
    self.bulletinData = [[BulletinData alloc] initWithPostDayCount:5];
    [self.bulletinData retrieveHTMLDataWithRefresh:refresh];
    self.bulletinData.delegate = self;
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

- (IBAction)filter:(id)sender {
    
# warning implementation needed
    
}

#pragma mark - UI Button


-(void)setUpButtons{
    
    self.moreButton.mdButtonDelegate = self;
    self.moreButton.rotated = NO;
    
    //invisible all related buttons
    self.feedbackButton.alpha = 0.f;
    self.expandCollapseButton.alpha = 0.f;
    self.filterButton.alpha = 0.f;
    
    _startPoint = CGPointMake(self.moreButton.center.x, self.moreButton.center.y + 100);
    self.feedbackButton.center = _startPoint;
    self.expandCollapseButton.center = _startPoint;
    self.filterButton.center = _startPoint;
    [self.moreButton setImageSize:28.0f];
}

- (IBAction)moreButtonClicked:(id)sender {
    
    if (sender == self.moreButton)
        self.moreButton.rotated = NO; //reset floating finging button
    if (sender == self.expandCollapseButton) {
        
        self._isExpanded = !self._isExpanded;
        [self.postsView reloadData];
        
        if (self._isExpanded)   [self.expandCollapseButton setImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateNormal];
        else                    [self.expandCollapseButton setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
    }
    
    if (sender == self.filterButton) {
#warning missing implementation
    }
    if (sender == self.feedbackButton) {
#warning missing implementation
    }
}

-(void)rotationStarted:(id)sender {
    
    if (self.moreButton == sender){
        int padding = 80;
        CGFloat duration = 0.2f;
        if (!self.moreButton.isRotated) {
            [UIView animateWithDuration:duration delay:0.0 options: (UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveEaseOut) animations:^{
                self.feedbackButton.alpha = 1;
                self.feedbackButton.transform = CGAffineTransformMakeScale(1.0,.4);
                self.feedbackButton.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -padding*3.5f), CGAffineTransformMakeScale(1.0, 1.0));
                
                self.filterButton.alpha = 1;
                self.filterButton.transform = CGAffineTransformMakeScale(1.0,.5);
                self.filterButton.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -padding*2.8f), CGAffineTransformMakeScale(1.0, 1.0));
                
                self.expandCollapseButton.alpha = 1;
                self.expandCollapseButton.transform = CGAffineTransformMakeScale(1.0,.6);
                self.expandCollapseButton.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -padding*2.1), CGAffineTransformMakeScale(1.0, 1.0));
                
            } completion:^(BOOL finished) { }];
        } else {
            [UIView animateWithDuration:duration/2 delay:0.0 options: kNilOptions animations:^{
                self.feedbackButton.alpha = 0;
                self.feedbackButton.transform = CGAffineTransformMakeTranslation(0, 0);
                
                self.filterButton.alpha = 0;
                self.filterButton.transform = CGAffineTransformMakeTranslation(0, 0);
                
                self.expandCollapseButton.alpha = 0;
                self.expandCollapseButton.transform = CGAffineTransformMakeTranslation(0, 0);
                
            } completion:^(BOOL finished) { }];
        }
    }
}

#pragma mark - View lifecycle

-(void)viewDidLayoutSubviews{
    _startPoint = CGPointMake(self.moreButton.center.x, self.moreButton.center.y + 100);
    self.feedbackButton.center = _startPoint;
    self.expandCollapseButton.center = _startPoint;
    self.filterButton.center = _startPoint;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    //just a reminder, also call viewDidLoad before all the setup.
    
    [super viewDidLoad];
    
    [self setUpButtons];
    
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
    [refreshControl addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postsView addSubview:refreshControl];
    self.postsView.alwaysBounceVertical = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined | [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied | [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        [self.locationManager requestWhenInUseAuthorization];
    else
        [self getForcast];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[DetailViewController class]]) {
        DetailViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = self.postsView.indexPathsForSelectedItems.firstObject;
        Post *post = self.bulletinData.bulletinData[indexPath.section].posts[indexPath.row];
        
        vc.postURL = post.link;
        vc.contentString = post.content;
        vc.contentImage = post.imageLink;
        vc.titleString = post.title;
    }
}

@end
