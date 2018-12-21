//
//  PreferenceViewController.m
//  DA Mobile
//
//  Created by Yongyang Nie on 5/17/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "PreferenceViewController.h"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController

-(void)switchNotification:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"notificationON"];
}

#pragma mark - UITableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Short Cut";
            break;
        case 1:
            return @"Personalize";
            break;
        case 2:
            return @"Others";
            break;
            
        default:
            break;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:[[self.imageNames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.customSwitch.hidden = YES;
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.customSwitch.hidden = NO;
        [cell.customSwitch setSelected:[[NSUserDefaults standardUserDefaults] boolForKey:@"notificationON"]];
        cell.delegate = self;
    }
    cell.title.text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.data objectAtIndex:section] count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dainfo.deerfield.edu"] options:@{} completionHandler:nil];
                    break;
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mail.deerfield.edu/owa"] options:@{} completionHandler:nil];
                    break;
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://deerfield.instructure.com/"] options:@{} completionHandler:nil];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"showTips" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"showCredit" sender:nil];
                    break;
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://goo.gl/forms/E8Y643yPuPW3bmDZ2"] options:@{} completionHandler:nil];
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}


- (void)viewDidLoad {

    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }

    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:@"DA Info", @"Deerfield Email", @"Canvas", nil];
    NSMutableArray *section2 = [NSMutableArray arrayWithObjects:@"Menu Notification", @"Location Access", nil];
    NSMutableArray *section3 = [NSMutableArray arrayWithObjects:@"Tips", @"Credit", @"Feedback", nil];
    self.data = [NSMutableArray arrayWithObjects:section1, section2, section3, nil];
    
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"dainfo", @"email", @"canvas", nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:@"notification", @"location", nil];
    NSMutableArray *a3 = [NSMutableArray arrayWithObjects:@"tips", @"credit", @"feedback.png", nil];
    self.imageNames = [NSMutableArray arrayWithObjects:a1, a2, a3, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
