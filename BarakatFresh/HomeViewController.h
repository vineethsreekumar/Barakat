//
//  HomeViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"
#import "NCMenu.h"
@interface HomeViewController : UIViewController<KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NCMenuDelegate>
{
    NSMutableArray * datasource;
}
@property (strong, nonatomic) IBOutlet UIView *main_slideview;
- (IBAction)menu_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *categoryScrollview;
@property (strong, nonatomic) NSMutableArray *innerdatarray;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic, strong) NCMenu *newsCubeMenu;
@property (strong, nonatomic) IBOutlet UIView *menu_view;
@property (strong, nonatomic) IBOutlet UILabel *cart_lbl;
 @property (strong, nonatomic) NSMutableArray *tempcartarray;
- (IBAction)searchview_buttonClick:(id)sender;
- (IBAction)myaccount_buttonClick:(id)sender;
- (IBAction)Home_buttonClick:(id)sender;
- (IBAction)Cart_buttonClick:(id)sender;
- (IBAction)cart_tabbuttonClick:(id)sender;

@end
