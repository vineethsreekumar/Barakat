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


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *passcontentarray;
- (IBAction)Applycoupon_buttonClick:(id)sender;
- (IBAction)ApplyVoucher_buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *coupontextfield;
@property (strong, nonatomic) IBOutlet UITextField *vouchertextfield;



@end
