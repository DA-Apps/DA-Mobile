//
//  ViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "BulletinViewController.h"
#import "TFHpple.h"

int cellIndex = 0;
int colorIndex = 0;

@interface BulletinViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property BOOL panBegin;

@end

@implementation BulletinViewController

-(void)saveToBookMark:(UICollectionViewCellPosts *)cell{
    
    NSIndexPath *index = [self.postsView indexPathForCell:cell];
    NSDictionary *dic = [[[self.posts objectAtIndex:index.section] objectForKey:@"posts"] objectAtIndex:index.row];
    [self savePosts:[dic objectForKey:@"title"] withContent:[dic objectForKey:@"summery"] withImage:[dic objectForKey:@"image"] withLink:[dic objectForKey:@"link"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post Saved" message:@"You have bookmarked this post" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CollectionHeaderDelegate

-(void)expandBirthday{
    
    if (self.headerContent.lastObject.count == 0) {
        [self.headerContent replaceObjectAtIndex:1 withObject:[self.posts.firstObject objectForKey:@"birthdays"]];
    }else{
        [self.headerContent replaceObjectAtIndex:1 withObject:[NSMutableArray array]];
    }
    CollectionReusableHeader *header = (CollectionReusableHeader *)[self.postsView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [header.table reloadData];
    
    [self.postsView performBatchUpdates:nil completion:nil];
}

-(void)expandMenu{
    
    int heightAnimation = 0;
    
    if (self.headerContent.firstObject.count == 0) {
        [self.headerContent replaceObjectAtIndex:0 withObject:self.upcomingMeals];
        heightAnimation = 120;
    }else{
        [self.headerContent replaceObjectAtIndex:0 withObject:[NSMutableArray array]];
        heightAnimation = -120;
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
    
    if (indexPath.row == 0)
        cellIndex = 0;
    
    switch (cellIndex) {
        case 0:
            cellIndex = 1;
            return CGSizeMake(self.view.frame.size.width, 260);
            break;
        case 1:
            cellIndex = 2;
            return CGSizeMake(self.view.frame.size.width, 160);
            break;
        case 2:
            cellIndex = 0;
            return CGSizeMake(self.view.frame.size.width, 160);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.view.frame.size.width, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 0, 12, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPost" forIndexPath:indexPath];
    
    if(cell.frame.size.height == 160){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPostSmall" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0f green:246.0/255.0f blue:247.0/255.0f alpha:1.0];
    }else
        cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = [[[self.posts objectAtIndex:indexPath.section] objectForKey:@"posts"] objectAtIndex:indexPath.row];
    cell.title.text = [dic objectForKey:@"title"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.image.layer.cornerRadius = 5;
    cell.image.layer.masksToBounds = YES;
    cell.delegate = self;
    cell.canSwipe = YES;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(NSMutableArray *)[self.posts[section] objectForKey:@"posts"] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.posts.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.headerContent.firstObject.count == 0 && self.headerContent.lastObject.count == 0 && section == 0)
        return CGSizeMake(self.postsView.frame.size.width, 190);
    else if (section != 0)
        return CGSizeMake(self.postsView.frame.size.width, 110);
    else
        return CGSizeMake(self.postsView.frame.size.width, 300);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.dateLabel.text = [self dateDescription:[[self.posts objectAtIndex:indexPath.section] objectForKey:@"date"]];
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

-(NSString *)dateDescription:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM dd"];
    return [formatter stringFromDate:date];
}

-(void)getPostsData:(TFHpple *)parser{
    
    self.posts = [NSMutableArray array];
    NSArray *allPosts = [parser searchWithXPathQuery:@"//div[@class='posts']"];
    
    //loop for five days--------------------------------------------------
    for (int i = 0; i < 5; i++) {
        
        NSMutableArray *dailyPosts = [NSMutableArray array];
        
        TFHppleElement *hppleElement = allPosts[i];
        
        NSArray *posts = [hppleElement searchWithXPathQuery:@"//ul[@class='posts-list daily-posts']/li"];
        
        //parse out all the birthdays--------------------------------------
        NSArray *birthdayData = [hppleElement searchWithXPathQuery:@"//div[@class='content-summary-badge daily birthday']"];
        NSMutableArray *birthdays = [self parseBirthdays:birthdayData];
        
        //parse out all the posts------------------------------------------
        for (TFHppleElement *element in posts) {
            //get image src
            NSArray *imgs = [element searchWithXPathQuery:@"//a[@data-lightbox='gallerySet']"];
            NSString *imgSrc = [[(TFHppleElement *)[imgs firstObject] attributes] objectForKey:@"href"];
            
            NSString *link = [[[[element firstChildWithTagName:@"div"] firstChildWithTagName:@"a"] attributes] objectForKey:@"href"];
            
            //search for title of post
            NSArray *titles = [element searchWithXPathQuery:@"//h2[@class='summary-title']"];
            NSString *title = [self cleanString:[(TFHppleElement *)[titles firstObject] text]];
            
            //search for summery of post
            NSArray *summeries = [element searchWithXPathQuery:@"//p[@class='summary-excerpt']"];
            NSString *summery = [self cleanString:[(TFHppleElement *)[summeries firstObject] text]];
            
            //construct the dic
            if (title && summery && [title isKindOfClass:[NSString class]] && [summery isKindOfClass:[NSString class]] && link){
                NSDictionary *dic = @{@"img_src": imgSrc? imgSrc : @"nil",
                                      @"title": title,
                                      @"summery": summery ? summery : @"No Summery",
                                      @"image": imgSrc ? imgSrc : @"placeholder.png",
                                      @"link": link};
                
                [dailyPosts addObject:dic];
            }
        }
        NSDictionary *oneDay = @{@"posts": dailyPosts,
                                 @"date": [NSDate dateWithTimeInterval:-86400*i sinceDate:[NSDate date]],
                                 @"birthdays": birthdays? birthdays: [NSMutableArray arrayWithObjects:@"No birthdays", nil]};
        [self.posts addObject:oneDay];
    }
    
}

-(NSMutableArray *)parseBirthdays:(NSArray *)birthdayData{
    
    if (birthdayData.count != 0 && self.birthdays == 0) {
        NSArray *content = [(TFHppleElement *)birthdayData.firstObject searchWithXPathQuery:@"//div[@class='summary-excerpt']"];
        
        NSString *birthday = [self cleanString:[[[(TFHppleElement *)content.firstObject content] stringByReplacingOccurrencesOfString:@"Happy birthday to" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""]];
        NSArray* elements = [birthday componentsSeparatedByString:@"."];
        return [NSMutableArray arrayWithArray:elements];
    }else{
        return nil;
    }
}

-(NSString *)cleanString:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return string;
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
    int i = arc4random()%4;
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
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
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


-(void)cacheData:(NSMutableArray <NSDictionary *> *)posts menu:(NSMutableArray *)nextMeal{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    [sharedDefaults setObject:posts forKey:@"posts"];
    [sharedDefaults setObject:nextMeal forKey:@"nextMeal"];
    [sharedDefaults synchronize];
}

-(void)loadCachedData{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    self.posts = [sharedDefaults objectForKey:@"posts"];
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
        if (hour < 12) mealType = @"BRUNCH";
        else mealType = @"DINNER";
    } else {
        if (hour < 9)
            mealType = @"BREAKFAST";
        else if (hour < 13) mealType = @"LUNCH";
        else mealType = @"DINNER";
    }
    if (hour > 18) {
        mealType = @"BREAKFAST";
        currentTime = [NSDate dateWithTimeInterval:86400 sinceDate:currentTime];
        [formatter setDateFormat:@"yyyy-MM-dd-"];
        key = [formatter stringFromDate: currentTime];
    }
    key = [key stringByAppendingString:mealType];
    NSArray *foods =[data searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li", key]];
    for (TFHppleElement *element in foods)
        [self.upcomingMeals addObject:element.content];
}

-(void)startRefresh:(UIRefreshControl *)refresh{
    
    if (self.posts.count == 0) {
        self.activityIndicator.hidden = NO;
        self.activityIndicator.tintColor = [UIColor grayColor];
        self.activityIndicator.type = DGActivityIndicatorAnimationTypeThreeDots;
        [self.activityIndicator startAnimating];
    }
    
    NSDate *methodStart = [NSDate date];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        if([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL.path]){
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:documentsDirectoryURL.path error:&error]; //Delete old file
            NSLog(@"%@", error);
        }
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                TFHpple *hpple = [TFHpple hppleWithHTMLData:[NSData dataWithContentsOfURL:filePath]];
                [self getPostsData:hpple];
                [self parseMenu:hpple];
                [self cacheData:self.posts menu:self.upcomingMeals];
                NSLog(@"finished");
                [self.postsView reloadData];
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                NSDate *methodFinish = [NSDate date];
                NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
                NSLog(@"executionTime = %f", executionTime);
                [refresh endRefreshing];
            });
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps" message:@"We couldn't retrieve data. Please quit the app and reopen" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    [downloadTask resume];
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
    
    self.headerContent = [NSMutableArray array];
    [self.headerContent addObject:[NSMutableArray array]];
    [self.headerContent addObject:[NSMutableArray array]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.postsView addSubview:refreshControl];
    self.postsView.alwaysBounceVertical = YES;
    
    [self loadCachedData];
    if (self.posts == nil) {
        [self startRefresh:refreshControl];
    }
    [self.postsView reloadData];
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [segue destinationViewController];
        DetailViewController *vc = (DetailViewController *)[nav topViewController];
        NSIndexPath *indexPath = self.postsView.indexPathsForSelectedItems.firstObject;
        NSDictionary *dic = [[[self.posts objectAtIndex:indexPath.section] objectForKey:@"posts"] objectAtIndex:indexPath.row];
        
        vc.postURL = [dic objectForKey:@"link"];
        vc.contentString = [dic objectForKey:@"summery"];
        vc.contentImage = [dic objectForKey:@"img_src"];
        vc.titleString = [dic objectForKey:@"title"];
    }
}

@end

