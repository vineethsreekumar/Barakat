//
//  LoginViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "LoginViewController.h"
#import "Config.h"
#define kOFFSET_FOR_KEYBOARD 80.0

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
    
    self.email_txtfield.delegate=self;
    self.password_textfield.delegate=self;
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)DoneButtonPressed{
    [self.email_txtfield resignFirstResponder];
    [self.password_textfield resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}

- (IBAction)signin_buttonClick:(id)sender {
   
    [self Loginpostmethod];
}
-(void)Loginpostmethod
{
    NSString *username = [self.email_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.password_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(username.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter Email" withTitle:@"Message"];
        
        return;
        
    }
    else  if(password.length == 0)
    {
        
        [uAppDelegate showMessage:@"Please enter Password" withTitle:@"Message"];
        
        return;
        
    }
    [indicator startAnimating];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:username forKey:@"userName"];
    [post setValue:password forKey:@"password"];
   // NSError *writeError = nil;
   // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
   // NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"User/LoginUser"];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s?userName=%@&password=%@",baseURL,"User/LoginUser",username,password];
   // NSString * encodedString = [urlstring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    //[request setURL:[NSURL URLWithString:urlStr]];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"GET"];
    //[urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          if([[res valueForKey:@"data"] count]>0)
          {
          dispatch_async(dispatch_get_main_queue(), ^{
                  [indicator stopAnimating];
          NSDictionary *obj = [[res valueForKey:@"data"] objectAtIndex:0];
          
          [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"customerId"] forKey:@"customerId"];
          [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"userName"] forKey:@"userName"];
          [[NSUserDefaults standardUserDefaults] synchronize];
              [self.navigationController popViewControllerAnimated:NO];
                    });
          //  NSString *outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [indicator stopAnimating];
                  
                  [uAppDelegate showMessage:@"Login error" withTitle:@"Message"];
              });


          }
          NSLog(@"webresponse=%@",res);
        /*  if(res.count > 0)
          {
             
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [indicator stopAnimating];
                  
                  [uAppDelegate showMessage:@"Login error" withTitle:@"Message"];
              });
              
              
          }*/
      }] resume];
    
}


- (IBAction)signup_buttonClick:(id)sender {
    RegisterViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
    [self.navigationController pushViewController:ViewController animated:YES];
}


@end
