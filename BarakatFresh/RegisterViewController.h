//
//  RegisterViewController.h
//  CareSynchrony
//
//  Created by imagiNETVentures on 24/02/17.
//  Copyright © 2017 imaginet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
     UIActivityIndicatorView *indicator;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *firstname_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *lastname_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *email_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *mobile_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *facility_txtfield;
@property (strong, nonatomic) IBOutlet UITextField *password_txtfield;
@property (strong, nonatomic) IBOutlet UITextField *confirm_password;
@property (strong, nonatomic) IBOutlet UIButton *accept_button;


- (IBAction)submit_ButtonClick:(id)sender;
- (IBAction)back_ButtonClick:(id)sender;

@end
