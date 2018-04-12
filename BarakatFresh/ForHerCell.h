//
//  ForHerCell.h
//  Dairam
//
//  Created by Satish kumar on 19/01/15.
//  Copyright (c) 2015 Mawaqaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForHerCell : UIView

@property (weak, nonatomic) IBOutlet UIView *forHerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *forHerImage;
@property (weak, nonatomic) IBOutlet UILabel *forHerProductName;
@property (weak, nonatomic) IBOutlet UILabel *forHerPrice;
@property (weak, nonatomic) IBOutlet UILabel *forHerDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UIView *inside_view;
@property (strong, nonatomic) IBOutlet UIView *bottom_view;
@property (strong, nonatomic) IBOutlet UILabel *cart_lbl;
@property (strong, nonatomic) IBOutlet UILabel *detail_lbl;

- (IBAction)image_view_buttonclick:(id)sender;
- (IBAction)details_buttonclick:(id)sender;
- (IBAction)addtocart_click:(id)sender;

- (IBAction)close_buttonclick:(id)sender;

@end
