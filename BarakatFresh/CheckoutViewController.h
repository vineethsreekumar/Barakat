//
//  CheckoutViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/3/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *accept_button;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)submit_ButtonClick:(id)sender;
- (IBAction)back_ButtonClick:(id)sender;


@property(nonatomic,strong) NSMutableArray *contentArray;

@property(strong,nonatomic) UIDatePicker *datePicker;
@property(strong,nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *passcontentarray;
- (IBAction)Applycoupon_buttonClick:(id)sender;
- (IBAction)ApplyVoucher_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *coupontextfield;
@property (strong, nonatomic) IBOutlet UITextField *vouchertextfield;
@property (strong, nonatomic) IBOutlet UITextField *datefield;
@property (strong, nonatomic) IBOutlet UITextField *time_field;
@property (strong, nonatomic) IBOutlet UITextField *delivery_Area;
@property (strong, nonatomic) IBOutlet UITextField *delivery_address;
@property (strong, nonatomic) IBOutlet UITextField *nearestlandmark;
@property (strong, nonatomic) IBOutlet UIButton *creditdebitbutton;
@property (strong, nonatomic) IBOutlet UIButton *cashondeliverybutton;
- (IBAction)creditdebit_buttonClick:(id)sender;
- (IBAction)cashondelivery_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email_textfield;
@property (strong, nonatomic) IBOutlet UITextField *mobile_textfield;
@property (strong, nonatomic) IBOutlet UITextField *password_textfield;
@property (strong, nonatomic) IBOutlet UITextField *confirm_password;
@property (strong, nonatomic) IBOutlet UIButton *couponapply_button;
@property (strong, nonatomic) IBOutlet UIButton *voucherapply_button;
@property (strong, nonatomic) IBOutlet UIButton *coupon_deletebutton;
@property (strong, nonatomic) IBOutlet UIButton *voucher_deletebutton;

- (IBAction)coupondelete_buttonClick:(id)sender;
- (IBAction)Voucherdelete_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *subtotal_lbl;
@property (strong, nonatomic) IBOutlet UILabel *discount_lbl;

@property (strong, nonatomic) IBOutlet UILabel *total_lbl;

@end
