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

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return nil;
}


-(void)setShadowforView:(UIView *)view{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath ];
    cell.textLabel.text = [self.foods objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foods.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1
    NSURL *tutorialsUrl = [NSURL URLWithString:@"https://deerfield.edu/bulletin"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    // 2
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // 3
    NSString *tutorialsXpathQueryString = @"//li[@class='dh-dish-name']";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSLog(@"%@", tutorialsNodes);
    
    // 4
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        
        // 5
        [objects addObject:[[element firstChild] content]];
    }
    
    self.foods = objects;
    [self.table reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self setShadowforView:self.menuView];
    [self setShadowforView:self.weatherView];
    [self setShadowforView:self.table];
    self.menuWidth.constant = self.view.frame.size.width / 2 - 8;
    self.weatherWidth.constant = self.view.frame.size.width / 2 - 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
