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

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.table]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.textLabel.text = [self.foods objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCellid" forIndexPath:indexPath];
        NSDictionary *dic = [self.weathers objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@ - %@", [dic objectForKey:@"low"], [dic objectForKey:@"high"]];
        cell.textLabel.text = [dic objectForKey:@"date"];
        cell.detailTextLabel.text = str;
        cell.imageView.image = [ViewController imageWithImage:[UIImage imageNamed:@"rainy"] scaledToSize:CGSizeMake(25, 25)];
        return cell;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.table]) {
        return self.foods.count;
    }else{
        return self.weathers.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - CollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCellPosts *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idCellPost" forIndexPath:indexPath];
    NSDictionary *dic = [self.posts objectAtIndex:indexPath.row];
    cell.title.text = [dic objectForKey:@"title"];
    cell.summery.text = [dic objectForKey:@"summery"];
    cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"img_src"]]]];
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
    
    // 3
    NSString *tutorialsXpathQueryString = @"//li[@class='dh-dish-name']";
    NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];
    
    // 4
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        
        [objects addObject:[[element firstChild] content]];
    }
    
    self.foods = objects;
}

-(NSMutableArray *)getPostsData:(TFHpple *)parser{
    
    NSString *tutorialsXpathQueryString = @"//div[@class='content-summary-badge small has-thumbnail daily-link']";
    NSArray *tutorialsNodes = [parser searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in tutorialsNodes) {
    
        //get image src
        NSArray *imgs = [element searchWithXPathQuery:@"//img[@class='attachment-post-thumbnail size-post-thumbnail wp-post-image']"];
        NSString *imgSrc = [[(TFHppleElement *)[imgs firstObject] attributes] objectForKey:@"src"];
        
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
        
        //retreive timestamp
        NSString *timeStamp = [[[element firstChildWithTagName:@"div"] firstChildWithClassName:@"summary-meta"] text];
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        //construct the dic
        NSDictionary *dic = @{@"timestamp": timeStamp,
                              @"img_src": imgSrc,
                              @"title": title,
                              @"summery": summery};
        
        if (objects.count > 5)
            break;
        else
            [objects addObject:dic];
        
    }
    return objects;
}

-(void)setupShadows{
    [self setShadowforView:self.menuView masksToBounds:NO];
    [self setShadowforView:self.weatherView masksToBounds:NO];
    [self setShadowforView:self.table masksToBounds:YES];
    [self setShadowforView:self.weatherTable masksToBounds:YES];
    [self setShadowforView:self.postsBackground masksToBounds:NO];
    //[self setShadowforView:self.postsView masksToBounds:YES];
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
        [self.weathers removeLastObject];
        [self.weatherTable reloadData];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps" message:@"We couldn't get the weather data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getForcast];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self setupShadows];
    self.menuWidth.constant = self.view.frame.size.width / 2 - 8;
    self.weatherWidth.constant = self.view.frame.size.width / 2 - 8;
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self getForcast];
    
    TFHpple *data = [self retrieveData];
    [self parseMenuData:data];
    self.posts = [self getPostsData:data];
    
    self.postsView.dataSource = self;
    self.postsView.delegate = self;
    [self.postsView reloadData];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
