//
//  ItemDetailViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/16/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSMutableDictionary *passarray;

@property (strong, nonatomic) IBOutlet UIImageView *itemimage;
@property (strong, nonatomic) IBOutlet UITextView *desc_txtview;
@property (strong, nonatomic) IBOutlet UITextView *nutrition_txtview;
@property (strong, nonatomic) IBOutlet UITextView *storingins_txtview;
@property (strong, nonatomic) IBOutlet UILabel *itemtitle;
@property (strong, nonatomic) IBOutlet UILabel *itemprice;
@property (strong, nonatomic) IBOutlet UILabel *itemweight;
@property (strong, nonatomic) IBOutlet UILabel *quantity_lbl;
 @property (strong, nonatomic) NSMutableArray *tempcartarray;
@property (strong, nonatomic) NSMutableArray *innerarray;
@property (strong, nonatomic) NSMutableArray *dataArray;
- (IBAction)minus_buttonClick:(id)sender;
- (IBAction)plus_buttonClick:(id)sender;
- (IBAction)Addtocart_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descheightconstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *benifitsheightconstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *useheightconstraint;
@property (strong, nonatomic) IBOutlet UILabel *origin_lbl;
@property (strong, nonatomic) IBOutlet UITextField *category_txtfield;

@end
