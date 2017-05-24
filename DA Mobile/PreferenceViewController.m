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
            return @"Customize";
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
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dainfo.deerfield.edu"]];
                    break;
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mail.deerfield.edu/owa"]];
                    break;
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://deerfield.instructure.com/"]];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)viewDidLoad {
    
    self.icon.layer.cornerRadius = 10.0f;
    self.icon.clipsToBounds = YES;
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:@"DA Info", @"Deerfield Email", @"Canvas", nil];
    NSMutableArray *section2 = [NSMutableArray arrayWithObjects:@"Menu Notification", @"Location Access", nil];
    NSMutableArray *section3 = [NSMutableArray arrayWithObjects:@"Tips", @"Credit", nil];
    self.data = [NSMutableArray arrayWithObjects:section1, section2, section3, nil];
    
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"dainfo", @"email", @"canvas", nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:@"notification", @"location", nil];
    NSMutableArray *a3 = [NSMutableArray arrayWithObjects:@"tips", @"credit", nil];
    self.imageNames = [NSMutableArray arrayWithObjects:a1, a2, a3, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
