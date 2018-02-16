
//
//  CollectionReusableHeader.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "CollectionReusableHeader.h"

@implementation CollectionReusableHeader

-(IBAction)openSchedule:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deerfield.edu/wp-content/uploads/2014/08/FINAL-opening-days-schedule-17-Sept.-5-1.pdf"] options:@{} completionHandler:nil];
}

-(IBAction)openRotation:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://deerfield.edu/to-do/2017/09/first-table-rotation-posted-with-waiters/10249366/"] options:@{} completionHandler:nil];
}

-(void)buttonClicked:(UIButton *)button{
    if (button.tag == 0) {
        [self.delegate expandMenu];
    }else{
        [self.delegate expandBirthday];
    }
    if (self.tableConstraint.constant == 190) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableConstraint.constant = 198;
            [self layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.tableConstraint.constant = 88;
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - UITableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
        return @"upcoming meal";
    else
        return @"birthdays";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 10, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width - 10, 22)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 40, view.center.y - 15, 30, 30)];
    [button setTitle:@"+" forState:UIControlStateNormal];
    button.tag = section;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    
    if (self.array[section].count == 0) {
        [button setTitle:@"+" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"-" forState:UIControlStateNormal];
    }
    
    NSString *string;
    if (section == 0)
        string = @"next meal";
    else
        string = @"birthdays";
    
    [label setText:string];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:label];
    [view addSubview:button];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array[section].count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end
