//
//  ViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 11/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "SWRevealViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && self.weathers == nil) {
        [self getForcast];
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


#pragma mark - UITableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.table])
        return @"upcoming meal";
    else
        return @"forecast";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 10, 22)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 10, 22)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    
    if ([tableView isEqual:self.weatherTable]) {
        NSString *string = @"forecast";
        [label setText:string];
        [view setBackgroundColor:[UIColor whiteColor]];
    }else{
        NSString *string = @"upcoming meal";
        [label setText:string];
        [view setBackgroundColor:[UIColor colorWithRed:38.0/255.0 green:137.0/255.0 blue:40.0/255.0 alpha:1.0]];
        label.textColor = [UIColor whiteColor];
    }
    
    [view addSubview:label];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.table]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = [self.foods objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCellid" forIndexPath:indexPath];
        
        //find the dictionary in self.weathers array at the correct index.
        NSDictionary *dic = [self.weathers objectAtIndex:indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"%@ - %@", [dic objectForKey:@"low"], [dic objectForKey:@"high"]];
        cell.textLabel.text = [dic objectForKey:@"date"];
        cell.detailTextLabel.text = str;
        cell.imageView.image = [ViewController imageWithImage:[self setWeatherImage:[dic objectForKey:@"text"]] scaledToSize:CGSizeMake(25, 25)];
        
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.table])
        return self.foods.count;
    else
        return self.weathers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width - 10, 200);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPost" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.posts objectAtIndex:indexPath.row];
    cell.title.text = [dic objectForKey:@"title"];
    cell.summery.text = [dic objectForKey:@"summery"];
    
    if ([[dic objectForKey:@"img_src"] isEqualToString:@"nil"])
        cell.postWidth.constant = cell.frame.size.width;
    else
        cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"img_src"]]]];
    
    [self setShadowforView:cell masksToBounds:NO];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - Private

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)setShadowforView:(UIView *)view masksToBounds:(BOOL)masksToBounds{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = masksToBounds;
}

-(TFHpple *)retrieveData{
    
    NSURL *tutorialsUrl = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    return [TFHpple hppleWithHTMLData:tutorialsHtmlData];
}

-(void)parseMenuData:(TFHpple *)parser{
    
    NSString *tutorialsXpathQueryString = @"//ul[@class='dh-meal-container active-dh-meal-container']/li";
    NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes)
        [objects addObject:[[element firstChild] content]];
    
    if (objects.count == 0)
        self.table.hidden = YES;
    else{
        self.foods = objects;
        self.table.hidden = NO;
        [self.table reloadData];
    }
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

-(NSMutableArray *)queryWeatherAPI{
    
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
        NSDictionary *dic = results[@"query"][@"results"][@"channel"][@"item"][@"condition"];
        [array addObject:dic];
        return array;
    }
}

-(void)getForcast{
    
    self.weathers = [self queryWeatherAPI];
    
    if (self.weathers) {
        self.tempLabel.text = [[self.weathers lastObject] objectForKey:@"temp"];
        self.weatherIcon.image = [self setWeatherImage: [[self.weathers lastObject] objectForKey:@"text"]];
        [self.weathers removeLastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherTable reloadData];
        });
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
    
    [sharedDefaults setObject:self.foods forKey:@"menuData"];
    [sharedDefaults setObject:self.weathers forKey:@"weatherData"];
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

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self setupShadows];
    self.menuWidth.constant = self.view.frame.size.width / 2 + 10;
    self.weatherWidth.constant = self.view.frame.size.width / 2 - 25;
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [self.locationManager requestWhenInUseAuthorization];
    else
        [self getForcast];
    
    TFHpple *data = [self retrieveData];
    [self parseMenuData:data];
    self.posts = [self getPostsData:data];
    [self.postsView reloadData];
    
    [self syncExtension];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
