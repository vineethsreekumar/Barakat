//
//  RegisterViewController.m
//  CareSynchrony
//
//  Created by imagiNETVentures on 24/02/17.
//  Copyright © 2017 imaginet. All rights reserved.
//

#import "RegisterViewController.h"
#import <MessageUI/MessageUI.h>
#import "Config.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
int activetag=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self nextbutton];
    [self donebutton];
    self.firstname_txtfield.delegate = self;
    self.lastname_txtfield.delegate = self;
    self.email_txtfield.delegate = self;
    self.mobile_txtfield.delegate = self;
    self.password_txtfield.delegate=self;
    self.confirm_password.delegate=self;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    // Do any additional setup after loading the view.
}
/*
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"run");
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+500);
}*/
-(void)donebutton
{
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    
    
    
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    // self.subjecttextfield.inputView = categoryPickerView;
    self.confirm_password.inputAccessoryView = pickerToolbar;
    
}
-(void)DoneButtonPressed{
    [self.confirm_password resignFirstResponder];
}
-(void)nextbutton
{
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(categoryDoneButtonPressed)];
    UIBarButtonItem *barButtonnext = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(NextButtonPressed)];
    
    
    
    [pickerToolbar setItems:@[flexSpace, flexSpace, barButtonnext] animated:YES];
    // self.subjecttextfield.inputView = categoryPickerView;
    self.firstname_txtfield.inputAccessoryView = pickerToolbar;
    self.lastname_txtfield.inputAccessoryView = pickerToolbar;
    self.email_txtfield.inputAccessoryView = pickerToolbar;
    self.mobile_txtfield.inputAccessoryView = pickerToolbar;
    self.password_txtfield.inputAccessoryView=pickerToolbar;

    
    
}
-(void)NextButtonPressed{
    if(activetag<=6)
    {
        UITextField *txtfield = (UITextField *)[self.view viewWithTag:activetag+1];
        [txtfield becomeFirstResponder];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activetag = (int)textField.tag;
    if(activetag>2)
    {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y+250);
    [self.scrollview setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollview setContentOffset:CGPointZero animated:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)submit_ButtonClick:(id)sender {
    NSString *firstnameString = [self.firstname_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastnameString = [self.lastname_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *emailString = [self.email_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *mobileString = [self.mobile_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.password_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(firstnameString.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter First Name" withTitle:@"Message"];
        
        return;
        
    }
    else  if(lastnameString.length == 0)
    {
        
        [uAppDelegate showMessage:@"Please enter Last Name" withTitle:@"Message"];

        return;
        
    }
    else  if(emailString.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter Email" withTitle:@"Message"];
        return;
        
    }
    else  if(mobileString.length == 0)
    {
        
        [uAppDelegate showMessage:@"Please enter Mobile Number" withTitle:@"Message"];
        return;

        
    }
    else  if(password.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter Password" withTitle:@"Message"];
        return;
        
        
    }
    else  if(self.accept_button.selected ==false)
    {
        [uAppDelegate showMessage:@"Please accept the terms and conditions" withTitle:@"Message"];
        return;
        
        
    }
    else
    {
        
       // [self showEmail:sender];
        [self register_servicepostmethod];
    }
    
    
    
    
    
    
    
}


-(void)register_servicepostmethod
{
    
    [indicator startAnimating];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    
    [post setValue:self.firstname_txtfield.text forKey:@"FirstName"];
    [post setValue:self.lastname_txtfield.text forKey:@"LastName"];
    [post setValue:self.email_txtfield.text forKey:@"Email"];
    [post setValue:self.mobile_txtfield.text forKey:@"MobileNumber"];
    [post setValue:self.password_txtfield.text forKey:@"Password"];
    [post setValue:self.confirm_password.text forKey:@"ConfirmPassword"];
    [post setValue:[NSNumber numberWithBool:YES] forKey:@"TermsandCondition"];
    [post setValue:[NSNumber numberWithBool:YES] forKey:@"IsActivated"];
    [post setValue:[NSNumber numberWithBool:YES] forKey:@"Status"];
    [post setValue:@"" forKey:@"GoogleMapLink"];
   
   
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",subURL,"CustomerRegistration"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          [indicator stopAnimating];
          dispatch_async(dispatch_get_main_queue(), ^{
               NSError *error1;
               NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
              if([[[res valueForKey:@"status"] stringValue] isEqual:@"-1"])
              {
                  NSMutableArray *error =[res valueForKey:@"error"];
                  
                  [uAppDelegate showMessage:[[[error valueForKey:@"ErrorMessage"] objectAtIndex:0] objectAtIndex:0]  withTitle:@"Message"];
              }
              if([[[res valueForKey:@"status"] stringValue] isEqual:@"0"])
              {
                  NSString *error =[res valueForKey:@"error"];
                  
                  [uAppDelegate showMessage:error  withTitle:@"Message"];
              }
              else
              {
              
              NSString *outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              [uAppDelegate showMessage:@"Registraion Successful. Please follow the email to complete" withTitle:@"Message"];
                  self.firstname_txtfield.text=@"";
                  self.lastname_txtfield.text=@"";
                  self.email_txtfield.text=@"";
                  self.mobile_txtfield.text=@"";
                  self.password_txtfield.text=@"";
                  self.confirm_password.text=@"";
                  self.accept_button.selected=false;

              if([outputString isEqualToString:@"\"Success\""])
              {
                  
              }
              }
              
          });
      }] resume];
    
}


- (IBAction)Accept_ButtonClick:(id)sender {
    UIButton *accept =(UIButton*)sender;
    if(accept.selected == YES)
    {
        accept.selected =NO;
    }
    else
    {
        accept.selected =YES;
    }
}


- (IBAction)back_ButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
