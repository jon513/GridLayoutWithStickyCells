

#import <UIKit/UIKit.h>

@interface JRGridLayoutWithStickyCellsLayout : UICollectionViewLayout
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger columnsToStickOnLeft;
@property (nonatomic, assign) NSInteger rowsToStickOnTop;
@end

@protocol JRGridLayoutWithStickyCellsLayoutDelegate <UICollectionViewDelegate>

-(CGFloat) collectionView:(UICollectionView*) collectionView widthForColumAtIndex:(NSInteger) rowIndex;
-(CGFloat) collectionView:(UICollectionView*) collectionView heightForRowAtIndex:(NSInteger) sectionIndex;

@end
