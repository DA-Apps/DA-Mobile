//
//  DetailViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 2/16/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
            cell.title.text = self.titleString;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            cell.image.image = self.contentImage;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            cell.content.text = self.contentString;
            break;
        default:
            break;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 75;
            break;
        case 1:
            return 200;
            break;
        case 2:
            return self.contentString.length / 50 * 25;
            break;
            
        default:
            return 0;
            break;
    }
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
