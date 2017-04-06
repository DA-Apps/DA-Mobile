//
//  ViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

int cellIndex = 0;
int colorIndex = 0;

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && self.weather == nil) {
        [self getForcast];
        NSLog(@"getting forcast");
    }
}

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
    
    if (indexPath.row == 0) {
        cellIndex = 0;
    }
    
    switch (cellIndex) {
        case 0:
            cellIndex = 1;
            if ([[[self.posts objectAtIndex:indexPath.row] objectForKey:@"img_src"] isEqualToString:@"nil"]) {
                return CGSizeMake(self.view.frame.size.width, 200);
            }else{
                return CGSizeMake(self.view.frame.size.width, 280);
            }
            break;
        case 1:
            cellIndex = 2;
            if ([[[self.posts objectAtIndex:indexPath.row] objectForKey:@"img_src"] isEqualToString:@"nil"]) {
                return CGSizeMake((self.view.frame.size.width-2) / 2, 300);
            }else{
                return CGSizeMake((self.view.frame.size.width-2) / 2, 300);
            }
            break;
        case 2:
            cellIndex = 0;
            if ([[[self.posts objectAtIndex:indexPath.row] objectForKey:@"img_src"] isEqualToString:@"nil"])
                return CGSizeMake((self.view.frame.size.width-2) / 2, 300);
            else
                return CGSizeMake((self.view.frame.size.width-2) / 2, 300);
            break;
            
        default:
            break;
    }
    return CGSizeMake(self.view.frame.size.width - 10, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 0, 12, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPost" forIndexPath:indexPath];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    NSDictionary *dic = [self.posts objectAtIndex:indexPath.row];
    cell.title.text = [dic objectForKey:@"title"];

    if(cell.frame.size.width > (self.view.frame.size.width-2) / 2){
        cell.backgroundColor = [UIColor clearColor];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:246.0/255.0f green:246.0/255.0f blue:247.0/255.0f alpha:1.0];
        cell.textHeight.constant = 80;
    }
    
    if ([[dic objectForKey:@"img_src"] isEqualToString:@"nil"]){
        cell.image.hidden = YES;
        cell.summery.hidden = NO;
        cell.indicator.hidden = YES;
        cell.summery.text = [dic objectForKey:@"summery"];
    }else{

        cell.image.hidden = NO;
        cell.indicator.hidden = YES;
        cell.image.image = [self.images objectAtIndex:indexPath.row];
        cell.image.layer.cornerRadius = 5;
        cell.image.layer.masksToBounds = YES;
        cell.summery.hidden = YES;
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionReusableHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.dateLabel.text = [self dateDescription];
        headerView.tempLabel.text = @"68";
        reusableview = headerView;
    }

    return reusableview;
}

#pragma mark - Private

-(NSString *)dateDescription{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM dd"];
    NSDate *today = [NSDate date];
    return [formatter stringFromDate:today];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)setShadowforView:(UIView *)view masksToBounds:(BOOL)masksToBounds{
    
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = masksToBounds;
}

-(NSMutableArray *)getPostsData:(TFHpple *)parser{
    
    NSArray *dailyPosts = [parser searchWithXPathQuery:@"//div[@class='posts']"];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        
        TFHppleElement *hppleElement = dailyPosts[i];
        
        NSArray *posts = [[[hppleElement searchWithXPathQuery:@"//li[@class='summary daily-summary posts student-news  first']"] arrayByAddingObjectsFromArray:
                          [hppleElement searchWithXPathQuery:@"//li[@class='summary daily-summary posts student-news ']"]] arrayByAddingObjectsFromArray:
                          [hppleElement searchWithXPathQuery:@"//li[@class='summary daily-summary posts student-news  last']"]];

        for (TFHppleElement *element in posts) {
            //get image src
            NSArray *imgs = [element searchWithXPathQuery:@"//a[@data-lightbox='gallerySet']"];
            NSString *imgSrc = [[(TFHppleElement *)[imgs firstObject] attributes] objectForKey:@"href"];
            
            if (imgSrc) {
                [self.images addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgSrc]]]];
            }else{
                [self.images addObject:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            //search for title of post
            NSArray *titles = [element searchWithXPathQuery:@"//h2[@class='summary-title']"];
            NSString *title = [(TFHppleElement *)[titles firstObject] text];
            title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            title = [title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            //search for summery of post
            NSArray *summeries = [element searchWithXPathQuery:@"//p[@class='summary-excerpt']"];
            NSString *summery = [(TFHppleElement *)[summeries firstObject] text];
            summery = [summery stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            summery = [summery stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            //construct the dic
            NSDictionary *dic;
            if (title && summery && [title isKindOfClass:[NSString class]] && [summery isKindOfClass:[NSString class]])
                dic = @{@"img_src": imgSrc? imgSrc : @"nil",
                        @"title": title,
                        @"summery": summery};
            
            if (dic)
                [objects addObject:dic];
        }
    }
    return objects;
}

-(void)setupShadows{
    [self setShadowforView:self.table masksToBounds:YES];
    [self setShadowforView:self.weatherTable masksToBounds:YES];
    [self setShadowforView:self.weatherView masksToBounds:NO];
    [self setShadowforView:self.menuView masksToBounds:NO];
}

-(NSDictionary *)queryWeatherAPI{
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    YQL *yql = [[YQL alloc] init];
    
    NSString *woeidQuery = [NSString stringWithFormat:@"SELECT woeid FROM geo.places WHERE text=\"(%f,%f)\"", coordinate.latitude, coordinate.longitude];
    NSDictionary *woeidResults = [yql query:woeidQuery];
    NSString *woeid = [[[[woeidResults objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"place"] objectForKey:@"woeid"];
    NSString *queryString = [NSString stringWithFormat:@"select * from weather.forecast where woeid in (%@)", woeid];
    
    NSDictionary *results = [yql query:queryString];
    if ([[[results objectForKey:@"query"] objectForKey:@"count"] intValue] == 0) {
        return nil;
        
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:results[@"query"][@"results"][@"channel"][@"item"][@"forecast"]];
        return (NSDictionary *)array.firstObject;
    }
}

-(void)getForcast{
    
    self.weather = [self queryWeatherAPI];
    
    if (self.weather) {
        self.tempLabel.text = [self.weather objectForKey:@"temp"];
        self.weatherIcon.image = [self setWeatherImage: [self.weather objectForKey:@"text"]];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps" message:@"We couldn't get the weather data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getForcast];
        }];
        [alert addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)syncExtension{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dabulletin"];
    
//    [sharedDefaults setObject:self.foods forKey:@"menuData"];
//    [sharedDefaults setObject:self.weathers forKey:@"weatherData"];
    [sharedDefaults synchronize];
}

-(UIImage*) setWeatherImage:(NSString*) weatherType {
    
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

-(void)startRefresh:(UIRefreshControl *)refresh{
    
    NSLog(@"begin");
    NSURL *url = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData  * _Nonnull data, NSURLResponse * _Nonnull response, NSError *_Nonnull error) {
        TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.posts = [self getPostsData:hpple];
                [self.postsView reloadData];
                [self syncExtension];
                [refresh endRefreshing];
                NSLog(@"finished");
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
    }] resume];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [self setupShadows];
    self.menuWidth.constant = self.view.frame.size.width / 2 + 10;
    self.weatherWidth.constant = self.view.frame.size.width / 2 - 25;
    self.images = [NSMutableArray array];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.postsView addSubview:refreshControl];
    self.postsView.alwaysBounceVertical = YES;

    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [self.locationManager requestWhenInUseAuthorization];
    else
        [self getForcast];
    
    [super viewDidLoad];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[DetailViewController class]]) {
        DetailViewController *vc = [segue destinationViewController];
        NSDictionary *dic = [self.posts objectAtIndex:self.postsView.indexPathsForSelectedItems.firstObject.row];
        
        vc.contentString = [dic objectForKey:@"summery"];
        vc.contentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"img_src"]]]];
        vc.titleString = [dic objectForKey:@"title"];
    }
}

@end
