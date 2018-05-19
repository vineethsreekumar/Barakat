//
//  ItemDetailViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/16/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailViewController : UIViewController
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
- (IBAction)minus_buttonClick:(id)sender;
- (IBAction)plus_buttonClick:(id)sender;
- (IBAction)Addtocart_buttonClick:(id)sender;

@end
