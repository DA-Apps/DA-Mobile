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
    
    NSLog(@"%@", objects);
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"Front View", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
    UIViewController *stubController = [[UIViewController alloc] init];
    stubController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:stubController animated:YES];
}

@end
