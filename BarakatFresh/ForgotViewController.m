//
//  ForgotViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/15/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "ForgotViewController.h"
#import "Config.h"
@interface ForgotViewController ()

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.email_txtfield.inputAccessoryView = pickerToolbar;
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    // Do any additional setup after loading the view.
}
-(void)DoneButtonPressed{
    [self.email_txtfield resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back_buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit_buttonClick:(id)sender {
    [self forgotserviceCall];
}

-(void)forgotserviceCall
{
     NSString *username = [self.email_txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(username.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter Email" withTitle:@"Message"];
        
        return;
        
    }
    [indicator startAnimating];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:username forKey:@"userName"];
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Customer/ForgotPassword"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if([res valueForKey:@"data"])
                  {
                       [uAppDelegate showMessage:@"A link has been sent to your Email to reset password" withTitle:@"Message"];
                  }
                  else
                  {
                      
                      [uAppDelegate showMessage:@"An error occured" withTitle:@"Message"];
                  }
                  [indicator stopAnimating];
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
    

}
@end
