//
//  UICollectionView+Seperator.m
//  DA-Mobile
//
//  Created by Yongyang Nie on 5/27/18.
//  Copyright © 2018 Yongyang Nie. All rights reserved.
//

#import "UICollectionView+Separators.h"
@import ObjectiveC;

#pragma mark -
#pragma mark -

@interface UICollectionViewLayoutAttributes (SEPLayoutAttributes)

@property (nonatomic, strong) UIColor *sep_separatorColor;

@end

@implementation UICollectionViewLayoutAttributes (SEPLayoutAttributes)

- (void)setSep_separatorColor:(UIColor *)sep_separatorColor
{
    objc_setAssociatedObject(self, @selector(sep_separatorColor), sep_separatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)sep_separatorColor
{
    return objc_getAssociatedObject(self, @selector(sep_separatorColor));
}

@end

#pragma mark -
#pragma mark -

@interface SEPCollectionViewCellSeparatorView : UICollectionReusableView

@end

@implementation SEPCollectionViewCellSeparatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = layoutAttributes.frame;
    
    if (layoutAttributes.sep_separatorColor != nil)
    {
        self.backgroundColor = layoutAttributes.sep_separatorColor;
    }
}

@end

#pragma mark -
#pragma mark -

static NSString *const kCollectionViewCellSeparatorReuseId = @"kCollectionViewCellSeparatorReuseId";

@implementation UICollectionViewFlowLayout (SEPCellSeparators)

#pragma mark - Setters/getters

- (void)setSep_separatorColor:(UIColor *)sep_separatorColor
{
    objc_setAssociatedObject(self, @selector(sep_separatorColor), sep_separatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self invalidateLayout];
}

- (UIColor *)sep_separatorColor
{
    return objc_getAssociatedObject(self, @selector(sep_separatorColor));
}

- (void)setSep_useCellSeparators:(BOOL)sep_useCellSeparators
{
    if (self.sep_useCellSeparators != sep_useCellSeparators)
    {
        objc_setAssociatedObject(self, @selector(sep_useCellSeparators), @(sep_useCellSeparators), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self registerClass:[SEPCollectionViewCellSeparatorView class] forDecorationViewOfKind:kCollectionViewCellSeparatorReuseId];
        [self invalidateLayout];
    }
}

- (BOOL)sep_useCellSeparators
{
    return [objc_getAssociatedObject(self, @selector(sep_useCellSeparators)) boolValue];
}

#pragma mark - Method Swizzling

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(layoutAttributesForElementsInRect:);
        SEL swizzledSelector = @selector(swizzle_layoutAttributesForElementsInRect:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (NSArray<UICollectionViewLayoutAttributes *> *)swizzle_layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributesArray = [self swizzle_layoutAttributesForElementsInRect:rect];
    
    if (self.sep_useCellSeparators == NO)
    {
        return layoutAttributesArray;
    }
    
    CGFloat lineSpacing = self.minimumLineSpacing;
    
    NSMutableArray *decorationAttributes = [[NSMutableArray alloc] initWithCapacity:layoutAttributesArray.count];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray)
    {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        
        if (indexPath.item > 0)
        {
            id <UICollectionViewDelegateFlowLayout> delegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
            if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
            {
                lineSpacing = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:indexPath.section];
            }
            
            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kCollectionViewCellSeparatorReuseId withIndexPath:indexPath];
            CGRect cellFrame = layoutAttributes.frame;
            
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
            {
                separatorAttributes.frame = CGRectMake(cellFrame.origin.x - lineSpacing, cellFrame.origin.y, lineSpacing, cellFrame.size.height);
            }
            else
            {
                separatorAttributes.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y - lineSpacing, cellFrame.size.width, lineSpacing);
            }
            
            separatorAttributes.zIndex = 1000;
            
            separatorAttributes.sep_separatorColor = self.sep_separatorColor;
            
            [decorationAttributes addObject:separatorAttributes];
        }
    }
    
    return [layoutAttributesArray arrayByAddingObjectsFromArray:decorationAttributes];
}

@end

#pragma mark -
#pragma mark -

@implementation UICollectionView (Separators)

- (UICollectionViewFlowLayout *)sep_flowLayout
{
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
    {
        return (UICollectionViewFlowLayout *)self.collectionViewLayout;
    }
    return nil;
}

- (void)setSep_separatorColor:(UIColor *)sep_separatorColor
{
    [self.sep_flowLayout setSep_separatorColor:sep_separatorColor];
}

- (UIColor *)sep_separatorColor
{
    return [self.sep_flowLayout sep_separatorColor];
}

- (void)setSep_useCellSeparators:(BOOL)sep_useCellSeparators
{
    [self.sep_flowLayout setSep_useCellSeparators:sep_useCellSeparators];
}

- (BOOL)sep_useCellSeparators
{
    return [self.sep_flowLayout sep_useCellSeparators];
}

@end
