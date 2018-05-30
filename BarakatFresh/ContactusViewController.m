//
//  ContactusViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/26/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "ContactusViewController.h"

@interface ContactusViewController ()

@end

@implementation ContactusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.passtype isEqualToString:@"contactus"])
    {
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Contact" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    }else if([self.passtype isEqualToString:@"desclaimer"])
    {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    }
    else if([self.passtype isEqualToString:@"ourvalues"])
    {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"OurValues" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

    }
    else if([self.passtype isEqualToString:@"paymentmethod"])
    {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"PaymentMethod" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

    }
    else if([self.passtype isEqualToString:@"refund"])
    {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"ReturnPolicy" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

    }
  
    
    // Do any additional setup after loading the view.
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
