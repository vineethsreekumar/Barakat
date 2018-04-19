//
//  LoginViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *email_txtfield;
@property (strong, nonatomic) IBOutlet UITextField *password_textfield;
@property (strong, nonatomic) IBOutlet UIButton *signin_button;
- (IBAction)signin_buttonClick:(id)sender;


@end
