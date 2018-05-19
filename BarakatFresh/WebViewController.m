//
//  WebViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [_webview loadHTMLString:[NSString stringWithFormat:@"<html><form action=\"https://ipg.comtrust.ae/PaymentEx/MerchantPay/Payment?lang=en&layout=C0STCBVLEI\" method=\"post\"><input type=\"hidden\" name=\"TransactionID\" value=\"<%@>\"  /><input type=\"submit\" value=\"Proceed to Checkout\" style=\"visibility:hidden\" id=\"InputProceed\" /></form><html>",self.transactionid] baseURL:nil];
    NSString *data=[NSString stringWithFormat:@"<html><body onload=\"document.frm1.submit()\"> <form action=\"https://demo-ipg.comtrust.ae/PaymentEx/MerchantPay/Payment?lang=en&layout=C0STCBVLEI\" method=\"post\" name=\"frm1\"><input type=\"hidden\" name=\"TransactionID\" value=\"%@\"  /><input type=\"submit\" value=\"Proceed to Checkout\"  id=\"InputProceed\" /></form>",self.transactionid];
    //NSData *htmlData = [NSData datfr:htmlFile];
NSData* htmlData = [data dataUsingEncoding:NSUTF8StringEncoding];
    #ifdef baseURL
    #undef baseURL
    [_webview loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    #endif
    _webview.delegate=self;
    // Do any additional setup after loading the view.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Current URL = %@",webView.request.URL);
    NSString *string = [NSString stringWithFormat:@"%@",webView.request.URL];
    if ([string rangeOfString:@"transaction/Transaction"].location == NSNotFound) {
        NSLog(@"string does not contain bla");
    } else {
        NSLog(@"string contains bla!");
        [self updatetransaction_service];
    }
}
-(void)updatetransaction_service
{
    NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * cartarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:self.orderid forKey:@"OrderId"];
    [post setValue:self.transactionid forKey:@"TransactionId"];
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];

    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",subURL,"api/Order/UpdateTransaction"];
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
                  
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu_buttonClick:(id)sender {
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

@end
