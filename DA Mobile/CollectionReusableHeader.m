
//
//  CollectionReusableHeader.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "CollectionReusableHeader.h"

@implementation CollectionReusableHeader

-(void)buttonClicked:(UIButton *)button{
    if (button.tag == 0) {
        [self.delegate expandMenu];
    }else{
        [self.delegate expandBirthday];
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
    return 2;
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
        string = @"upcoming meal";
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
