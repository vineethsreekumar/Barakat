//
//  LoginViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.email_txtfield.inputAccessoryView = pickerToolbar;
    self.password_textfield.inputAccessoryView = pickerToolbar;
    
    UIView *viewRightIntxtFieldDate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:[UIImage imageNamed:@"Username_icon.png"]];
    [viewRightIntxtFieldDate addSubview:imageView];
    self.email_txtfield.leftViewMode = UITextFieldViewModeAlways;
    self.email_txtfield.leftView = viewRightIntxtFieldDate;
    
    // self.email_txtfield.leftViewMode = UITextFieldViewModeAlways;
    // self.email_txtfield.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Username_icon.png"]];
    //  self.password_textfield.leftViewMode = UITextFieldViewModeAlways;
    //  self.password_textfield.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Passwordicon.png"]];
    
    UIView *viewPassIntxtFieldDate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    UIImageView *imageViewpass = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    imageViewpass.contentMode = UIViewContentModeScaleAspectFit;
    [imageViewpass setImage:[UIImage imageNamed:@"Passwordicon.png"]];
    [viewPassIntxtFieldDate addSubview:imageViewpass];
    self.password_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.password_textfield.leftView = viewPassIntxtFieldDate;
    self.email_txtfield.layer.cornerRadius = 5;
    self.email_txtfield.layer.masksToBounds = YES;
    self.password_textfield.layer.cornerRadius = 5;
    self.password_textfield.layer.masksToBounds = YES;
    self.signin_button.layer.cornerRadius = 5;
    self.signin_button.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)DoneButtonPressed{
    [self.email_txtfield resignFirstResponder];
    [self.password_textfield resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signin_buttonClick:(id)sender {
}

@end
