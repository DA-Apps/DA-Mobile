//
//  CollectionReusableHeader.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
