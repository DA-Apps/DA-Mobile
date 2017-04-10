//
//  CollectionViewFlowLayout.m
//  DA Mobile
//
//  Created by Yongyang Nie on 4/7/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // This will schedule calls to layoutAttributesForElementsInRect: as the
    // collectionView is scrolling.
    return YES;
}

- (UICollectionViewScrollDirection)scrollDirection {
    // This subclass only supports vertical scrolling.
    return UICollectionViewScrollDirectionVertical;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    UICollectionView *collectionView = [self collectionView];
    CollectionReusableHeader *header = (CollectionReusableHeader *)[collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // First get the superclass attributes.
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // Check if we've pulled below past the lowest position
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        
        // Locate the header attributes
        NSString *kind = [attrs representedElementKind];
        if (kind == UICollectionElementKindSectionHeader) {
            
            CGRect headerRect = [attrs frame];
            // Adjust the header's height and y based on how much the user
            if (header.array.firstObject.count + header.array.lastObject.count == 0) {
                headerRect.size.height = 180;
            }else if (header.array.firstObject.count + header.array.lastObject.count < 3){
                [UIView animateWithDuration:0.3 animations:^{
                    header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y, header.frame.size.width, header.frame.size.height + 40);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y, header.frame.size.width, header.frame.size.height + 40);
                }];
            }
            
            [attrs setFrame:headerRect];
            break;
        }
    }
    return attributes;
}

@end
