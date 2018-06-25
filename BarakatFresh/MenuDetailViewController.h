//
//  MenuDetailViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/25/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *search_textfield;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) NSMutableArray *passcurrentarray;
@property (strong, nonatomic) NSMutableArray *tempcartarray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
- (IBAction)homebutton_click:(id)sender;
- (IBAction)searchbutton_Click:(id)sender;
- (IBAction)cartbutton_Click:(id)sender;
- (IBAction)myaccountbutton_Click:(id)sender;
- (IBAction)morebutton_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *cart_lbl;
- (IBAction)top_cartbuttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *sum_lbl;
@end
