//
//  SearchViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/19/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *search_textfield;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) NSMutableArray *tempcartarray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
- (IBAction)home_buttonClick:(id)sender;
- (IBAction)cart_buttonClick:(id)sender;
- (IBAction)myccount_buttonClick:(id)sender;
- (IBAction)more_buttonClick:(id)sender;
- (IBAction)Cart_buttonClick:(id)sender ;

@property (strong, nonatomic) IBOutlet UILabel *cart_lbl;
@property (strong, nonatomic) IBOutlet UILabel *sum_lbl;
@end
