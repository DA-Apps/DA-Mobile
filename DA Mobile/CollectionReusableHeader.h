//
//  CollectionReusableHeader.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableHeader : UICollectionReusableView <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableConstraint;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *array;
@property (strong, nonatomic) id delegate;

@end

@protocol CollectionReusableHeaderDelegate <NSObject>

-(void)expandMenu;
-(void)expandBirthday;

@end
