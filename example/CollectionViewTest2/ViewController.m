
#import "ViewController.h"

#import "ViewController.h"
#import "JRGridLayoutWithStickyCellsLayout.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, JRGridLayoutWithStickyCellsLayoutDelegate>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* users;
@property (nonatomic, strong) NSArray* headers;
@property (nonatomic, strong) NSString* sort;
@property (nonatomic, assign) BOOL ascending;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData* jsonData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users" ofType:@"json"]];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    self.users = [json[@"results"] mutableCopy];
    self.headers = @[@"name.first",@"name.last", @"gender",@"email", @"cell", @"nat",@"dob", @"location.city", @"location.state", @"location.street" ];
    JRGridLayoutWithStickyCellsLayout* layout = [[JRGridLayoutWithStickyCellsLayout alloc] init];
    layout.itemSize = CGSizeMake(75,40);
    layout.rowsToStickOnTop = 1;
    layout.columnsToStickOnLeft = 2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.collectionView];
}
-(CGFloat) collectionView:(UICollectionView*) collectionView widthForColumAtIndex:(NSInteger) rowIndex{
    const NSDictionary* widthLookup = @{@"name.first":@75,
                                        @"name.last":@75,
                                        @"gender" : @75,
                                        @"email":@180,
                                        @"cell":@90,
                                        @"nat":@35,
                                        @"dob":@150,
                                        @"location.city":@175,
                                        @"location.state":@120,
                                        @"location.street":@300 };
    
    return [widthLookup[self.headers[rowIndex]] floatValue];
    
}


-(CGFloat) collectionView:(UICollectionView*) collectionView heightForRowAtIndex:(NSInteger) sectionIndex{
    if (sectionIndex % 5 == 0) {
        return 75;
    }
    if (sectionIndex %7 ==0) {
        return 100;
    }
    if (sectionIndex % 11 ==0) {
        return 150;
    }
    return 40;
}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.users.count +1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.headers.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel* label = [cell viewWithTag:100];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
        NSString* headerText = self.headers[indexPath.row];
        NSString* sortSymbol = @"";
        if ([self.sort isEqualToString:headerText]) {
            if (self.ascending) {
                sortSymbol = @"▲ ";
            }else{
                sortSymbol = @"▼ ";
            }
        }
        label.text = [NSString stringWithFormat:@"%@%@", sortSymbol, headerText];
        
    }else {
        label.text = [NSString stringWithFormat:@"\u200e%@\u200e",[self.users[indexPath.section-1] valueForKeyPath:self.headers[indexPath.row]] ];
        
        if (indexPath.section %2){
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:0.57 green:0.82 blue:0.93 alpha:1.0];
            
        }
    }
    
    UIView* line = [cell.contentView viewWithTag:200];
    if (indexPath.row == 1) {
        if (!line) {
            line = [[UIView alloc] initWithFrame:CGRectZero];
            line.tag = 200;
            [cell.contentView addSubview:line];
        }
        line.frame = CGRectMake(cell.bounds.size.width - 0.5, 0, 0.5 , cell.bounds.size.height);
        line.backgroundColor = [UIColor blackColor];
        line.hidden = NO;
    }else{
        line.hidden = YES;
    }
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSString* updatedSort = self.headers[indexPath.row];
        if ([updatedSort isEqualToString:self.sort]) {
            self.ascending = !self.ascending;
        }
        self.sort = updatedSort;
        [self.users sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:self.sort ascending:self.ascending]]];
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, -self.collectionView.contentInset.top) animated:NO];
        [self.collectionView reloadData];
    }
    
}



@end
