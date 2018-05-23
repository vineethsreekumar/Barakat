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
@interface HomeViewController : UIViewController<KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NCMenuDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    NSMutableArray * datasource;
}
@property (strong, nonatomic) IBOutlet UIView *main_slideview;
- (IBAction)menu_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *categoryScrollview;
- (IBAction)more_buttonClick:(id)sender;
@property (strong, nonatomic) NSMutableArray *innerdatarray;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic, strong) NCMenu *newsCubeMenu;
@property(nonatomic, strong) UITextField *activetextfield;
@property(nonatomic, strong) UIImageView *activeimageview;
@property (strong, nonatomic) IBOutlet UIView *menu_view;
@property (strong, nonatomic) IBOutlet UILabel *cart_lbl;
@property (strong, nonatomic) NSMutableArray *tempcartarray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (nonatomic, assign) BOOL hasRun;
- (IBAction)searchview_buttonClick:(id)sender;
- (IBAction)myaccount_buttonClick:(id)sender;
- (IBAction)Home_buttonClick:(id)sender;
- (IBAction)Cart_buttonClick:(id)sender;
- (IBAction)cart_tabbuttonClick:(id)sender;

@end
